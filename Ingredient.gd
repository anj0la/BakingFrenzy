extends RigidBody2D
	
"""
An ingredient represents an object a player can collide with.

If the player collides with the ingreident, we simply output in the terminal "Collided!" for now.

At the beginning (before ready), we'll need to have a list of ingredient names. Ingredients appear at random, so
we simply need to get the name and change the default image texture of the Sprite2D.
"""

var ingredient_names = ["purple", "pink", "blue"] # Currently, only one ingredient name for now

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var rand_index = randi() % ingredient_names.size()
	$Sprite2D.texture = _get_texture(rand_index)
	
# Gets an ingredient image texture based on its index
func _get_texture(index: int) -> Texture2D:
	var image_path = "res://art/rect_" + ingredient_names[index] + ".png"
	var texture = load(image_path)
	return texture

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free() # Destroys the ingredients -- MIGHT CHANGE TO WHEN INGREDIENT REACHES THE GROUND
