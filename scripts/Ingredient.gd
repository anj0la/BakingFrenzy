extends StaticBody2D

"""
An ingredient represents an object a player can collide with.

If the player collides with the ingreident, we simply output in the terminal "Collided!" for now.

At the beginning (before ready), we'll need to have a list of ingredient names. Ingredients appear at random, so
we simply need to get the name and change the default image texture of the Sprite2D.
"""

var ingredient_names = ["blue", "red", "white", "green", "yellow"]

@export var speed: int = 6.0
@export var ingredient_name: String

func _physics_process(_delta):
	move_and_collide(Vector2(0, speed))

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var rand_index = randi() % ingredient_names.size()
	ingredient_name = ingredient_names[rand_index] 
	$Sprite2D.texture = _get_texture(rand_index)
	
# Gets an ingredient image texture based on its index.
func _get_texture(index: int) -> Texture2D:
	var image_path = "res://art/rect_" + ingredient_names[index] + ".png"
	var texture = load(image_path)
	return texture

# Sets the ingredient's sprite image based on the passed name.
func set_texture(ingredient_name: String):
	var image_path = "res://art/rect_" + ingredient_name + ".png" 	# Assumes that name is in ingredient_names.
	$Sprite2D.texture = load(image_path)

func _on_area_2d_body_entered(body: Node2D) -> void:
	print(body.name)
	if body.name == 'Floor':
		queue_free()
