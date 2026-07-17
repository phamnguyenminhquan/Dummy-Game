extends Control

@onready var join_button : Button = $JoinButton
@onready var create_button : Button = $CreateButton
@onready var refresh_button : Button = $ServerPanel/Container/RefreshButton
@onready var name_input : LineEdit = $LobbyName
@onready var room_list: ItemList = $ServerPanel/ScrollBar/RoomList

const PORT := 7000

var room_ips: Array[String] = [] #index = row

func _on_room_list_updated(rooms: Dictionary) -> void:
	room_list.clear()
	room_ips.clear()
	for ip in rooms.keys():
		var info = rooms[ip]
		room_list.add_item("%s (%d players)" % [info.name, info.players])
		room_ips.append(ip)
		
func _on_create_pressed() -> void:
	print("CREATE BUTTON PRESSED")
	var room_name = name_input.text if not name_input.text.is_empty() else "Default Room"
	var err := NetworkManager.create_game(room_name)
	if err == OK:
		get_tree().change_scene_to_file("res://tests/main_test.tscn")

func _on_refresh_pressed() -> void:
	room_list.clear()
	room_ips.clear()
	NetworkManager.search_for_rooms()
	
func _on_join_pressed() -> void:
	var selected := room_list.get_selected_items()
	if selected.is_empty():
		return
	var ip := room_ips[selected[0]]
	var err := NetworkManager.join_game(ip)
	if err == OK:
		get_tree().change_scene_to_file("res://tests/main_test.tscn")
func _ready() -> void:
	create_button.pressed.connect(_on_create_pressed)
	join_button.pressed.connect(_on_join_pressed)
	refresh_button.pressed.connect(_on_refresh_pressed)
	NetworkManager.room_list_updated.connect(_on_room_list_updated)
