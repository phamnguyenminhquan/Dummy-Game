extends Control
@onready var play_button: Button = $PlayButton
@onready var quit_button: Button = $QuitButton


func _ready() -> void:
	play_button.pressed.connect(_on_play_pressed)
	quit_button.pressed.connect(_on_quit_pressed)


func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/lobby/lobby.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
