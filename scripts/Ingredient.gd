extends CharacterBody2D

"""
An ingredient represents an object a player can collide with.

If the player collides with the ingreident, we simply output in the terminal "Collided!" for now.

At the beginning (before ready), we'll need to have a list of ingredient names. Ingredients appear at random, so
we simply need to get the name and change the default image texture of the Sprite2D.
"""

var ingredient_names = ["purple", "pink", "blue"] # Currently, only one ingredient name for now

@export var speed = 6.0

func _physics_process(_delta):
	var collision = move_and_collide(Vector2(0, speed))
	if collision:
		pass
		# print("I collided with ", collision.get_collider().name)
		#await get_tree().create_timer(0.2).timeout
		#queue_free()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var rand_index = randi() % ingredient_names.size()
	$Sprite2D.texture = _get_texture(rand_index)
	
# Gets an ingredient image texture based on its index
func _get_texture(index: int) -> Texture2D:
	var image_path = "res://art/rect_" + ingredient_names[index] + ".png"
	var texture = load(image_path)
	return texture
