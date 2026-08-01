extends Node2D

@onready var ready_button: Button = $LobbyUI/PanelContainer/Margin/Container/ReadyButton
@onready var start_button: Button = $LobbyUI/PanelContainer/Margin/Container/StartButton
@onready var player_list_container: VBoxContainer = $LobbyUI/PanelContainer/Margin/Container/PlayerListContainer
@onready var scene_container: Node2D = $SceneContainer

const LOBBY_SCENE := preload("res://scenes/waiting_room/lobby_scene.tscn")

func _ready() -> void:
	ready_button.pressed.connect(_on_ready_pressed)
	start_button.pressed.connect(_on_start_pressed)

	start_button.visible = multiplayer.is_server()
	start_button.disabled = true

	PlayerManager.players_state_updated.connect(_update_ui)

	_update_ui()
	GameManager.state_changed.connect(_on_state_changed)
	load_scene(LOBBY_SCENE)


func load_scene(packed_scene: PackedScene) -> void:
	for child in scene_container.get_children():
		child.queue_free()
	var instance = packed_scene.instantiate()
	scene_container.add_child(instance)
	print("[Main] Peer %d — loaded scene: %s" % [multiplayer.get_unique_id(), packed_scene.resource_path])


func _on_state_changed(new_state: Enums.GameState) -> void:
	match new_state:
		Enums.GameState.LOBBY:
			load_scene(LOBBY_SCENE)


func _on_ready_pressed() -> void:
	ready_button.disabled = true
	ServerManager.request_local_ready(true)


func _on_start_pressed() -> void:
	if not multiplayer.is_server():
		return
	GameManager.request_start_match()


func _update_ui() -> void:
	for child in player_list_container.get_children():
		child.queue_free()

	for id in PlayerManager.players_state:
		var row := HBoxContainer.new()
		row.add_theme_constant_override("separation", 8)

		var name_label := Label.new()
		name_label.text = "Player %d" % id
		name_label.add_theme_font_size_override("font_size", 15)
		name_label.add_theme_color_override("font_color", Color(0.85, 0.87, 0.95))
		name_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL

		var status_label := Label.new()
		var is_ready := PlayerManager.is_player_ready(id)
		status_label.text = "Ready" if is_ready else "Not Ready"
		status_label.add_theme_font_size_override("font_size", 15)
		status_label.add_theme_color_override(
			"font_color",
			Color(0.4, 0.85, 0.5) if is_ready else Color(0.8, 0.4, 0.4)
		)

		row.add_child(name_label)
		row.add_child(status_label)
		player_list_container.add_child(row)

	if multiplayer.is_server():
		start_button.disabled = not PlayerManager.all_players_ready()