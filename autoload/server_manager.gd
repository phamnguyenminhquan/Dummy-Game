extends Node

# Số lượng Impostor (sau này có thể để Host tự setting)
var num_impostors: int = 1

# Database nhiệm vụ được đóng gói dưới dạng Array[Dictionary]
var all_tasks_database: Array[Dictionary] = [
	{"title": "Fix Wiring", "description": "Connect matching wires in Electrical.", "point": 10},
	{"title": "Swipe Card", "description": "Swipe ID card in Admin room.", "point": 5},
	{"title": "Download Data", "description": "Download data from Weapons to Admin.", "point": 15},
	{"title": "Empty Garbage", "description": "Empty the garbage chute in Cafeteria.", "point": 10}
]

# Hàm này sẽ được gọi bên trong main_test.tscn khi Host bấm "Start Game"
func start_match():
	# Chỉ Server mới có quyền chia Role và Task
	if not multiplayer.is_server():
		return
		
	assign_roles()
	assign_tasks()

# ==========================================
# THẺ DM-02: LOGIC CHIA ROLE NGẪU NHIÊN
# ==========================================
func assign_roles():
	# Lấy danh sách ID người chơi thực tế từ PlayerManager
	var player_ids = PlayerManager.players_state.keys()
	player_ids.shuffle() # Xáo trộn ngẫu nhiên
	
	for i in range(player_ids.size()):
		var id = player_ids[i]
		var assigned_role = "Crewmate"
		
		if i < num_impostors:
			assigned_role = "Impostor"
			
		# 1. Cập nhật trạng thái Role trên máy chủ (Server state)
		PlayerManager.players_state[id]["role"] = assigned_role
		
		# 2. Gửi lệnh báo Role về đúng máy Client đó
		rpc_id(id, "receive_role", assigned_role)

# ==========================================
# THẺ DM-03: LOGIC CHIA TASK
# ==========================================
func assign_tasks():
	var player_ids = PlayerManager.players_state.keys()
	
	for id in player_ids:
		# Đọc Role mà Server vừa gán ở trên
		var role = PlayerManager.players_state[id]["role"]
		var assigned_tasks: Array = []
		
		if role == "Crewmate":
			# Bốc ngẫu nhiên 3 task cho Crewmate
			var shuffled_tasks = all_tasks_database.duplicate()
			shuffled_tasks.shuffle()
			assigned_tasks = shuffled_tasks.slice(0, 3)
		else:
			# Impostor nhận Fake Task
			assigned_tasks = [
				{"title": "Fake Task: Swipe Card", "description": "Pretend to swipe card.", "point": 0}
			]
			
		# Bắn danh sách task xuống Client
		rpc_id(id, "receive_task_list", assigned_tasks)

# ==========================================
# RPC CHO CLIENT - NƠI PQ SẼ VIẾT UI
# ==========================================
@rpc("authority", "call_remote", "reliable")
func receive_role(assigned_role: String):
	# Khi Client nhận được Role, cập nhật ngay vào biến local của nó
	PlayerManager.local_player_data["role"] = assigned_role
	print("[Client] Hệ thống vừa báo Role của tôi là: ", assigned_role)
	
	# TODO: PQ sẽ gọi hàm hiển thị màn hình Crewmate/Impostor ở đây

@rpc("authority", "call_remote", "reliable")
func receive_task_list(tasks_data: Array):
	print("[Client] Nhận được danh sách nhiệm vụ: ", tasks_data)
	
	# TODO: PQ sẽ lặp qua mảng này để nhét dữ liệu vào UI Danh sách nhiệm vụ
