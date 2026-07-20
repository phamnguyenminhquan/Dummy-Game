extends CharacterBody2D

# Movement speed of the player
@export var SPEED = 200.0

# References to child nodes
@onready var camera = $Camera2D
@onready var animation = $AnimatedSprite2D

func _ready():
	# If this player character belongs to the local machine, turn on the camera.
	# If it belongs to another player on the network, keep the camera off.
	if is_multiplayer_authority():
		camera.make_current()

func _enter_tree():
	var id = name.to_int()
	
	# 1. Cấp quyền điều khiển nhân vật cho Peer có ID này
	set_multiplayer_authority(id)
	
	# 2. CÁI NÀY QUAN TRỌNG: Cấp quyền cho cả node Synchronizer nữa!
	# (Thay "$MultiplayerSynchronizer" bằng tên chính xác của node đó trong scene của bạn)
	$MultiplayerSynchronizer.set_multiplayer_authority(id)

func _physics_process(_delta):
	# Only allow movement if the local machine owns this player
	if not is_multiplayer_authority():
		return
	
	# Get input direction as a Vector2 (returns 1, 0, or -1 for X and Y)
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if input_direction != Vector2.ZERO:
		velocity = input_direction * SPEED
		
		# --- ANIMATION LOGIC (Đã tối ưu) ---
		# 1. Luôn sử dụng cảnh "walk" cho mọi hướng di chuyển
		animation.animation = "walk"
		
		# Khóa lật dọc để nhân vật không bao giờ bị lộn ngược đầu khi đi lên/xuống
		animation.flip_v = false 
		
		# 2. Chỉ lật ảnh theo chiều ngang (flip_h) nếu có nhấn phím trái/phải
		if input_direction.x != 0:
			animation.flip_h = input_direction.x > 0
		
		# 3. Play animation
		if not animation.is_playing():
			animation.play("walk")
			# Ép hoạt ảnh nhảy sang frame 1 (nhấc chân) ngay lập tức khi vừa nhấn phím
			animation.frame = 1
	else:
		# Stop moving
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
		
		# 4. Stop the animation when standing still
		animation.stop()
		# Reset về frame đầu tiên (frame 0) để tạo dáng đứng im (Idle)
		animation.frame = 0
		
	# Apply the movement and handle collisions
	move_and_slide()
