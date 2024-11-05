extends Area2D

signal hit

@export var speed = 500
var screen_size

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	hide() # Hides the player by default

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var velocity = Vector2.ZERO # THe player's movement vector (0, 0) by default
	
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_right"):
		velocity.x += 1

	if velocity.x != 0:
		# $AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
		
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)

func _on_hit() -> void:
	print("Hit the block!")
	hit.emit()
	
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
