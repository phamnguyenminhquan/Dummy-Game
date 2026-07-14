extends CharacterBody2D

# Movement speed of the player
@export var SPEED = 500.0

# References to child nodes
@onready var camera = $Camera2D
@onready var animation = $AnimatedSprite2D

func _ready():
	# If this player character belongs to the local machine, turn on the camera.
	# If it belongs to another player on the network, keep the camera off.
	if is_multiplayer_authority():
		
		camera.make_current()

func _physics_process(_delta):
	# Only allow movement if the local machine owns this player
	if not is_multiplayer_authority():
		return
	
	# Get input direction as a Vector2 (returns 1, 0, or -1 for X and Y)
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if input_direction != Vector2.ZERO:
		velocity = input_direction * SPEED
		
		# --- ANIMATION LOGIC ---
		# 1. Flip the sprite depending on direction
		if input_direction.x != 0:
			animation.animation = "walk"
			# Prevent weird behavior
			animation.flip_v = false
			# If x is negative (moving left), flip_h becomes true
			animation.flip_h = input_direction.x < 0
		elif input_direction.y != 0:
			animation.animation = "up"
			# If y is positive (moving down), flip_v become true
			animation.flip_v = input_direction.y > 0
		
		# 2. Play animation
		animation.play()
	else:
		# Stop moving
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
		
		# 3. Stop the animation when standing still
		animation.stop()
		# Optional: Reset to the first frame so they look like they are in an "idle" stance
		animation.frame = 0
	# Apply the movement and handle collisions
	move_and_slide()
