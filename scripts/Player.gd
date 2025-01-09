extends CharacterBody2D

signal hit

const WALK_SPEED: int = 600
var screen_size: Vector2
var y_pos: float # Used to keep player on the same location on the y-axis at all times.
var move_player: bool

# Called before physics step and in sync with physics server.
func _physics_process(_delta):
	if move_player:
		velocity.y = 0 

		if Input.is_action_pressed("move_left"):
			velocity.x = -WALK_SPEED
		elif Input.is_action_pressed("move_right"):
			velocity.x = WALK_SPEED
		else:
			velocity.x = 0
			
		if velocity.x != 0:
			$AnimatedSprite2D.animation = "walk"
			$AnimatedSprite2D.flip_h = velocity.x > 0
			$AnimatedSprite2D.play()
		else:
			$AnimatedSprite2D.animation = "idle"

		# Move the player.
		move_and_slide()
		
		# Keep player at same positiion on the y-axis.
		position.y = y_pos
	# Stop player movement.
	else:
		velocity.x = 0
		$AnimatedSprite2D.stop()
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	hide() # Hides the player by default
	
# Positions and shows the player at the specified location.
func start(pos: Vector2) -> void:
	position = pos
	y_pos = position.y
	move_player = true
	show()
	$CollisionShape2D.disabled = false
	
# Stops player movement from being processed.
func stop_movement() -> void:
	move_player = false

# Signals that the player has been hit by a Node2D body.
func _on_area_2d_body_entered(body: Node2D) -> void:
	hit.emit(body)
