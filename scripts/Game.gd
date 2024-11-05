extends Node

@export var ingredient_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	$Player.start($StartPosition.position)

func _on_ingredient_timer_timeout() -> void:
	# Create a new instance of the Ingredient scene.
	var ingredient = ingredient_scene.instantiate()
	
	# var ingredient_spawn_location
	
	# Set the ingredient's position perpendicular to the path direction (direction -> horizontial, path -> vertical).
	
	# Set the ingredient's position to a random location.
	
	# Spawn the ingredient by adding it to the Game scene.
