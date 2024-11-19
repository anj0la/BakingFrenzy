extends StaticBody2D

@export var speed: float = 400.0
@export var ingredient_name: String
@export var recipe_manager: Resource

# Called before physics step and in sync with physics server.
func _physics_process(delta):
	move_and_collide(Vector2(0, speed * delta))

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ingredient_name = recipe_manager.select_ingredient()
	$Sprite2D.texture = _get_texture(ingredient_name)
	# Make ingredient available to player for collision detection.
	add_to_group("active_ingredient")
	
# Gets an ingredient image texture based on its index.
func _get_texture(ingredient: String) -> Texture2D:
	var image_path = "res://art/rect_" + ingredient + ".png"
	var texture = load(image_path)
	return texture

# Removes ingredients from the scene when they collide with the floor.
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == 'Floor':
		# Make ingredient inactive (cannot be collected by player).
		remove_from_group("active_ingredient")
		add_to_group("inactive_ingredient")
		queue_free()
