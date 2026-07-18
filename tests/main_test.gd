extends Node2D

func _input(event):
	# Giả lập nút "Bắt đầu game" bằng phím Space (hoặc Enter)
	if event.is_action_pressed("ui_accept"):
		# Chỉ cho phép Host (Server) mới được quyền bấm chia Role
		if multiplayer.is_server():
			print("\n[Host] Đang kích hoạt chia Role và Task cho mọi người...")
			ServerManager.start_match()
