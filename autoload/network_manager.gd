extends Node

# Signals for UI (Lobby/Gameplay) to listen to
signal player_connected(peer_id: int, player_info: Dictionary)
signal player_disconnected(peer_id: int)
signal server_disconnected
signal connection_failed

const PORT: int = 7000
const DEFAULT_SERVER_IP: String = "127.0.0.1" # IPv4 Localhost
const MAX_CONNECTIONS: int = 32

func _ready() -> void:
	# Connect Godot's built-in multiplayer connection events
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	multiplayer.connected_to_server.connect(_on_connected_ok)
	multiplayer.connection_failed.connect(_on_connected_fail)
	multiplayer.server_disconnected.connect(_on_server_disconnected)

# --- NETWORK SETUP ---

## Hosts a new game server
func create_game() -> Error:
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(PORT, MAX_CONNECTIONS)
	if error != OK:
		return error
	multiplayer.multiplayer_peer = peer
	
	# Since the Host is also a player, register the host locally immediately
	var host_id = 1
	PlayerManager.register_player(host_id, PlayerManager.get_local_network_data())
	player_connected.emit(host_id, PlayerManager.get_local_network_data())
	return OK

## Joins an existing game server using an IP address
func join_game(address: String = "") -> Error:
	if address.is_empty():
		address = DEFAULT_SERVER_IP
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_client(address, PORT)
	if error != OK:
		return error
	multiplayer.multiplayer_peer = peer
	return OK

## Cleans up the network peer and resets managers
func remove_multiplayer_peer() -> void:
	multiplayer.multiplayer_peer = OfflineMultiplayerPeer.new()
	PlayerManager.reset_manager()

# --- RPC DATA SYNCHRONIZATION ---

## RPC function used by clients to send their data to everyone else
@rpc("any_peer", "reliable")
func _register_player_rpc(player_info: Dictionary) -> void:
	var sender_id = multiplayer.get_remote_sender_id()
	
	# Save the received data into the PlayerManager's global state
	PlayerManager.register_player(sender_id, player_info)
	player_connected.emit(sender_id, player_info)

# --- SYSTEM MULTIPLAYER CALLBACKS ---

## Triggered on EVERY machine when a new peer successfully connects
func _on_peer_connected(id: int) -> void:
	# If we are the Server, we should send our player data to the newly connected peer.
	# (Advanced synchronization logic for existing players will also be handled here)
	pass

## Triggered when a peer disconnects from the session
func _on_peer_disconnected(id: int) -> void:
	PlayerManager.unregister_player(id)
	player_disconnected.emit(id)

## Triggered ONLY on the CLIENT when successfully connected to the Server
func _on_connected_ok() -> void:
	var local_id = multiplayer.get_unique_id()
	var my_data = PlayerManager.get_local_network_data()
	
	# Register self locally
	PlayerManager.register_player(local_id, my_data)
	player_connected.emit(local_id, my_data)
	
	# Send self data to the Server and other peers
	_register_player_rpc.rpc(my_data)

## Triggered ONLY on the CLIENT when connection attempt fails
func _on_connected_fail() -> void:
	remove_multiplayer_peer()
	connection_failed.emit()

## Triggered ONLY on the CLIENT when the SERVER disconnects or shuts down
func _on_server_disconnected() -> void:
	remove_multiplayer_peer()
	server_disconnected.emit()
