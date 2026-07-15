extends Control

func _on_server_pressed():
	NetworkManager.create_game()

func _on_client_pressed():
	NetworkManager.join_game()
