extends Node

# ==========================================
# VOTE MANAGER
# Server-authoritative meeting/voting flow. Owns nothing about match state
# itself — it drives GameManager's MEETING/VOTING stubs and hands the
# final result back to GameManager.end_match() / resume_after_vote().
#
# Flow:
#   call_meeting(caller_id)
#     -> GameManager.enter_meeting()          (state: MEETING)
#     -> broadcast alive player list to clients
#     -> start_voting()                        (after discussion, or immediately)
#     -> GameManager.enter_voting()            (state: VOTING)
#     -> clients call request_cast_vote(target_id)
#     -> once all alive players have voted (or timer expires) -> _resolve_votes()
#     -> ejects the top-voted player (or nobody, on tie/skip majority)
#     -> checks win conditions, otherwise GameManager.resume_after_vote()
# ==========================================

signal meeting_started(caller_id: int, alive_player_ids: Array)
signal voting_started(alive_player_ids: Array)
signal vote_tally_updated(votes_cast: int, total_alive: int)
signal voting_resolved(ejected_id: int, was_impostor: bool)



# Discussion time before voting opens automatically, in seconds.
var meeting_duration_sec: float = 15.0
# Voting time limit, in seconds. 0 = wait for everyone, no timeout.
var voting_duration_sec: float = 30.0

# peer_id (voter) -> peer_id (target) or SKIP_VOTE
var _votes: Dictionary = {}
var _meeting_timer: Timer
var _voting_timer: Timer


func _ready() -> void:
	_meeting_timer = Timer.new()
	_meeting_timer.one_shot = true
	_meeting_timer.timeout.connect(start_voting)
	add_child(_meeting_timer)

	_voting_timer = Timer.new()
	_voting_timer.one_shot = true
	_voting_timer.timeout.connect(_resolve_votes)
	add_child(_voting_timer)


# ==========================================
# --- MEETING / VOTING LIFECYCLE (server only) ---
# ==========================================

## Entry point for an emergency meeting button or a reported body.
func call_meeting(caller_id: int) -> void:
	if not multiplayer.is_server():
		return
	if GameManager.current_state != Enums.GameState.PLAYING:
		return

	_votes.clear()
	GameManager.enter_meeting()

	var alive_ids := _get_alive_player_ids()
	_broadcast_meeting_started(caller_id, alive_ids)

	_meeting_timer.start(meeting_duration_sec)


## Opens the floor for voting. Called automatically when the meeting timer
## runs out, but can also be called directly to skip straight to voting.
func start_voting() -> void:
	if not multiplayer.is_server():
		return
	if GameManager.current_state != Enums.GameState.MEETING:
		return

	_meeting_timer.stop()
	_votes.clear()
	GameManager.enter_voting()

	var alive_ids := _get_alive_player_ids()
	_broadcast_voting_started(alive_ids)

	if voting_duration_sec > 0.0:
		_voting_timer.start(voting_duration_sec)


## Called by a client (any_peer) casting their vote. target_id == SKIP_VOTE
## means "skip". Server validates the voter is alive and hasn't voted yet.
@rpc("any_peer", "call_remote", "reliable")
func request_cast_vote(target_id: int) -> void:
	if not multiplayer.is_server():
		return
	var voter_id = multiplayer.get_remote_sender_id()
	_try_cast_vote(voter_id, target_id)


## Host-local equivalent of request_cast_vote, call this directly from
## host-side UI instead of RPC-ing to itself.
func cast_vote_as_host(target_id: int) -> void:
	if not multiplayer.is_server():
		return
	_try_cast_vote(Constants.HOST_ID, target_id)


func _try_cast_vote(voter_id: int, target_id: int) -> void:
	if GameManager.current_state != Enums.GameState.VOTING:
		return
	if not PlayerManager.players_state.has(voter_id):
		return
	if not PlayerManager.players_state[voter_id].get("is_alive", false):
		push_warning("[VoteManager] Dead player %d tried to vote." % voter_id)
		return
	if _votes.has(voter_id):
		return # Already voted, ignore silently

	# target_id must be SKIP_VOTE or an alive player
	if target_id != Constants.SKIP_VOTE:
		if not PlayerManager.players_state.has(target_id):
			return
		if not PlayerManager.players_state[target_id].get("is_alive", false):
			return

	_votes[voter_id] = target_id
	_broadcast_vote_tally()

	# If everyone alive has voted, resolve immediately instead of waiting
	# for the timer.
	if _votes.size() >= _get_alive_player_ids().size():
		_resolve_votes()


# ==========================================
# --- TALLY / RESOLUTION ---
# ==========================================

func _resolve_votes() -> void:
	if not multiplayer.is_server():
		return
	if GameManager.current_state != Enums.GameState.VOTING:
		return

	_voting_timer.stop()

	# Count votes per target. SKIP_VOTE is tracked too, so it can outright
	# win and block an ejection.
	var tally: Dictionary = {} # target_id -> count
	for voter_id in _votes:
		var target_id = _votes[voter_id]
		tally[target_id] = tally.get(target_id, 0) + 1

	var ejected_id: int = Constants.SKIP_VOTE
	var highest_count: int = 0
	var is_tie := false

	for target_id in tally:
		var count = tally[target_id]
		if count > highest_count:
			highest_count = count
			ejected_id = target_id
			is_tie = false
		elif count == highest_count:
			is_tie = true

	if is_tie or ejected_id == Constants.SKIP_VOTE:
		ejected_id = Constants.SKIP_VOTE # Tie or skip-majority: nobody gets ejected

	var was_impostor := false
	if ejected_id != Constants.SKIP_VOTE and PlayerManager.players_state.has(ejected_id):
		PlayerManager.players_state[ejected_id]["is_alive"] = false
		was_impostor = PlayerManager.players_state[ejected_id]["role"] == Enums.Role.IMPOSTOR

	_broadcast_voting_result(ejected_id, was_impostor)
	_votes.clear()

	_check_post_vote_win_condition(was_impostor, ejected_id)


## After an ejection (or a skip), checks whether the match should end.
func _check_post_vote_win_condition(was_impostor: bool, ejected_id: int) -> void:
	if ejected_id != Constants.SKIP_VOTE and was_impostor and _count_alive_impostors() <= 0:
		GameManager.end_match(Enums.GameResult.CREWMATE_VICTORY_EJECT)
		return

	if _count_alive_impostors() >= _count_alive_crewmates():
		GameManager.end_match(Enums.GameResult.IMPOSTOR_VICTORY_KILLS)
		return

	GameManager.resume_after_vote()


# ==========================================
# --- HELPERS ---
# ==========================================

func _get_alive_player_ids() -> Array:
	var alive: Array = []
	for id in PlayerManager.players_state.keys():
		if PlayerManager.players_state[id].get("is_alive", false):
			alive.append(id)
	return alive


func _count_alive_impostors() -> int:
	var count := 0
	for id in PlayerManager.players_state.keys():
		var data = PlayerManager.players_state[id]
		if data.get("is_alive", false) and data["role"] == Enums.Role.IMPOSTOR:
			count += 1
	return count


func _count_alive_crewmates() -> int:
	var count := 0
	for id in PlayerManager.players_state.keys():
		var data = PlayerManager.players_state[id]
		if data.get("is_alive", false) and data["role"] == Enums.Role.CREWMATE:
			count += 1
	return count


# ==========================================
# --- NETWORK SYNC ---
# ==========================================

func _broadcast_meeting_started(caller_id: int, alive_ids: Array) -> void:
	meeting_started.emit(caller_id, alive_ids)
	for id in PlayerManager.players_state.keys():
		if id == Constants.HOST_ID:
			continue
		rpc_id(id, "_receive_meeting_started", caller_id, alive_ids)


func _broadcast_voting_started(alive_ids: Array) -> void:
	voting_started.emit(alive_ids)
	for id in PlayerManager.players_state.keys():
		if id == Constants.HOST_ID:
			continue
		rpc_id(id, "_receive_voting_started", alive_ids)


func _broadcast_vote_tally() -> void:
	var total_alive = _get_alive_player_ids().size()
	vote_tally_updated.emit(_votes.size(), total_alive)
	for id in PlayerManager.players_state.keys():
		if id == Constants.HOST_ID:
			continue
		rpc_id(id, "_receive_vote_tally", _votes.size(), total_alive)


func _broadcast_voting_result(ejected_id: int, was_impostor: bool) -> void:
	voting_resolved.emit(ejected_id, was_impostor)
	for id in PlayerManager.players_state.keys():
		if id == Constants.HOST_ID:
			continue
		rpc_id(id, "_receive_voting_result", ejected_id, was_impostor)


@rpc("authority", "call_remote", "reliable")
func _receive_meeting_started(caller_id: int, alive_ids: Array) -> void:
	meeting_started.emit(caller_id, alive_ids)


@rpc("authority", "call_remote", "reliable")
func _receive_voting_started(alive_ids: Array) -> void:
	voting_started.emit(alive_ids)


@rpc("authority", "call_remote", "reliable")
func _receive_vote_tally(votes_cast: int, total_alive: int) -> void:
	vote_tally_updated.emit(votes_cast, total_alive)


@rpc("authority", "call_remote", "reliable")
func _receive_voting_result(ejected_id: int, was_impostor: bool) -> void:
	voting_resolved.emit(ejected_id, was_impostor)
