extends StaticBody2D

var ingredient_names = ["blue", "red", "white", "green", "yellow"]

@export var speed: float = 6.0
@export var ingredient_name: String

# Called before physics step and in sync with physics server.
func _physics_process(_delta):
	move_and_collide(Vector2(0, speed))

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var rand_index = randi() % ingredient_names.size()
	ingredient_name = ingredient_names[rand_index] 
	$Sprite2D.texture = _get_texture(rand_index)
	# Make ingredient available to player for collision detection.
	add_to_group("active_ingredient")
	
# Gets an ingredient image texture based on its index.
func _get_texture(index: int) -> Texture2D:
	var image_path = "res://art/rect_" + ingredient_names[index] + ".png"
	var texture = load(image_path)
	return texture

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == 'Floor':
		# Make ingredient inactive (cannot be collected by player).
		remove_from_group("active_ingredient")
		add_to_group("inactive_ingredient")
		queue_free()
