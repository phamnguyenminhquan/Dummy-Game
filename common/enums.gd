class_name Enums
extends Node

# 1. Vai trò của người chơi
enum Role {
	CREWMATE,
	IMPOSTOR
}

# 2. Trạng thái của trận đấu (dùng cho GameManager)
enum GameState {
	LOBBY,        # Đang ở phòng chờ
	PLAYING,      # Đang làm nhiệm vụ
	MEETING,      # Đang họp / Thảo luận
	VOTING,       # Đang bỏ phiếu
	GAME_OVER     # Kết thúc trận
}

# 3. Phân loại loại Task (dùng cho TaskResource nếu cần)
enum TaskType {
	SHORT,        # Task ngắn (vd: Swipe card)
	LONG,         # Task dài (vd: Submit scan)
	COMMON        # Task chung cho tất cả crewmate (vd: Fix wiring)
}

# 4. Kết quả trận đấu
enum GameResult {
	CREWMATE_VICTORY_TASKS,    # Crewmate thắng nhờ làm xong hết Task
	CREWMATE_VICTORY_EJECT,    # Crewmate thắng nhờ vote hết Impostor
	IMPOSTOR_VICTORY_KILLS,    # Impostor thắng nhờ giết hết Crewmate
	IMPOSTOR_VICTORY_SABOTAGE  # Impostor thắng nhờ phá hoại
}
