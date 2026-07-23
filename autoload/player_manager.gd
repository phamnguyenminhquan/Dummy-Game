extends Node

# Local player's data (the player sitting in front of this screen)
var local_player_data: Dictionary = {
	"name": "Player",
	"role": Enums.Role.CREWMATE, # Default role, will be assigned when the game starts
	"is_alive": true,
	"assigned_tasks": [],
	"done_tasks": []
}

# Dictionary storing the game state/metadata of all players in the lobby/game
# Structure: { peer_id (int): player_data (Dictionary) }
var players_state: Dictionary = {}

## Returns the clean data package of the local player to be sent over the network
func get_local_network_data() -> Dictionary:
	return {
		"name": local_player_data["name"],
		"role": local_player_data["role"],
		"is_alive": local_player_data["is_alive"],
		"assigned_tasks": local_player_data["assigned_tasks"],
		"done_tasks": local_player_data["done_tasks"]
	}

## Registers or updates a player's data in the global state
func register_player(peer_id: int, player_data: Dictionary) -> void:
	players_state[peer_id] = player_data

## Removes a player from the active state (e.g., when they disconnect)
func unregister_player(peer_id: int) -> void:
	if players_state.has(peer_id):
		players_state.erase(peer_id)

## Resets all player states to default (useful when leaving a game)
func reset_manager() -> void:
	players_state.clear()
	local_player_data["role"] = Enums.Role.CREWMATE
	local_player_data["is_alive"] = true
	local_player_data["assigned_tasks"] = []
	local_player_data["done_tasks"] = []

func get_player_count() -> int:
	return players_state.size()
