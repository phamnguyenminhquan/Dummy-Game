extends Node

# ==========================================
# ROOM DISCOVERY MANAGER
# Handles LAN room discovery over raw UDP, completely separate from the
# ENet game connection in network_manager.gd. Its only job is figuring out
# which rooms exist and what their IP is, BEFORE any real connection happens.
# ==========================================

signal room_list_updated(rooms: Dictionary)

var room_name: String = "Default Room"
var discovery_server := PacketPeerUDP.new()
var discovery_client := PacketPeerUDP.new()
var is_hosting_broadcast: bool = false
var is_searching: bool = false
var found_room: Dictionary = {}  # ip_address -> {name, players}


func _process(_delta: float) -> void:
	# HOST SIDE: answer discovery pings from clients looking for rooms
	if is_hosting_broadcast and discovery_server.get_available_packet_count() > 0:
		var packet := discovery_server.get_packet().get_string_from_utf8()
		if packet == Constants.DISCOVERY_PING:
			var sender_ip := discovery_server.get_packet_ip()
			var sender_port := discovery_server.get_packet_port()
			var reply := "%s|%d" % [room_name, PlayerManager.get_player_count()]
			discovery_server.set_dest_address(sender_ip, sender_port)
			discovery_server.put_packet(reply.to_utf8_buffer())

	# CLIENT SIDE: collect replies while searching
	if is_searching and discovery_client.get_available_packet_count() > 0:
		var packet := discovery_client.get_packet().get_string_from_utf8()
		var sender_ip := discovery_client.get_packet_ip()
		var parts := packet.split("|")
		if parts.size() == 2:
			found_room[sender_ip] = {"name": parts[0], "players": int(parts[1])}
			room_list_updated.emit(found_room)


# ==========================================
# --- HOST SIDE ---
# ==========================================

## Starts answering discovery pings from clients. Call this when hosting a game.
func start_broadcasting(p_room_name: String = "Default Room") -> Error:
	if is_hosting_broadcast:
		stop_broadcasting()
	
	var error := discovery_server.bind(Constants.DISCOVERY_PORT)
	if error != OK:
		return error
	
	room_name = p_room_name
	is_hosting_broadcast = true
	return OK

## Stops answering discovery pings. Call this when the host leaves/shuts down,
## so the port is free if they host again later.
func stop_broadcasting() -> void:
	discovery_server.close()
	is_hosting_broadcast = false


# ==========================================
# --- CLIENT SIDE ---
# ==========================================

## Broadcasts a ping on the LAN and starts listening for replies.
## Results arrive asynchronously via the `room_list_updated` signal.
func search_for_rooms() -> void:
	found_room.clear()
	
	# Close any previous search socket before starting a new one
	discovery_client.close()
	
	# Bind is required to actually RECEIVE the host's reply packets,
	# not just send the ping. Port 0 lets the OS pick a free local port.
	var error := discovery_client.bind(0)
	if error != OK:
		push_warning("RoomDiscoveryManager: failed to bind discovery client (%s)" % error)
		return
	
	discovery_client.set_broadcast_enabled(true)
	discovery_client.set_dest_address("255.255.255.255", Constants.DISCOVERY_PORT)
	discovery_client.put_packet(Constants.DISCOVERY_PING.to_utf8_buffer())
	is_searching = true

## Stops listening for room replies and frees the socket.
func stop_searching() -> void:
	discovery_client.close()
	is_searching = false


# ==========================================
# --- CLEANUP ---
# ==========================================

## Resets everything, e.g. when leaving the lobby entirely.
func reset() -> void:
	stop_broadcasting()
	stop_searching()
	found_room.clear()
	room_name = "Default Room"
