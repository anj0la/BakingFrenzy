extends Node

@export var ingredient_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	$Player.start($StartPosition.position)
	$StartTimer.start()

func _on_ingredient_timer_timeout() -> void:
	# Create a new instance of the Ingredient scene.
	var ingredient = ingredient_scene.instantiate()
	
	# Choose a random location on Path2D.
	var ingredient_spawn_location = $IngredientPath/IngredientSpawnLocation
	ingredient_spawn_location.progress_ratio = randf()
	
	# Set the ingredient's position perpendicular to the path direction (direction -> horizontial, path -> vertical).
	var direction = ingredient_spawn_location.rotation + PI / 2
	
	# Set the ingredient's position to a random location.
	ingredient.position = ingredient_spawn_location.position
	ingredient.rotation = direction
	
	# Spawn the ingredient by adding it to the Game scene.
	add_child(ingredient)

func _on_start_timer_timeout() -> void:
	$IngredientTimer.start()
	print('Started ingredient timer.')


func _on_player_hit(body) -> void:
	print(body)
