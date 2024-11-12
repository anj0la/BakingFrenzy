extends CharacterBody2D

signal hit

const WALK_SPEED = 600
var screen_size
var y_pos # Used to keep player on the same location on the y-axis at all times.

# Called before physics step and in sync with physics server.
func _physics_process(_delta):
	velocity.y = 0 

	if Input.is_action_pressed("move_left"):
		velocity.x = -WALK_SPEED
	elif Input.is_action_pressed("move_right"):
		velocity.x = WALK_SPEED
	else:
		velocity.x = 0
		
	if velocity.x != 0:
		$AnimatedSprite2D.flip_h = velocity.x < 0
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()

	# Move the player.
	move_and_slide()
	
	# Keep player at same positiion on the y-axis.
	position.y = y_pos
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	hide() # Hides the player by default
	
# Positions and shows the player at the specified location.
func start(pos: Vector2) -> void:
	position = pos
	y_pos = position.y
	show()
	$CollisionShape2D.disabled = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	hit.emit(body)
