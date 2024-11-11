extends Node

@export var ingredient_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$Recipe.initialize_recipe()
	print($Recipe.selected_recipe)

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

# The problem arises when the ingredient hits the ground. need to add collision to ingredient to be destroyed when it touches the floor

func _on_player_hit(body: Node2D) -> void:
	# Check if collided ingredient is a part of the selected recipe.
	if body.name == "Ingredient":
		print(body.ingredient_name)
		# Ignore collision detection if the recipe has been completed or the player has collected the wrong ingredient.
		if not $Recipe.completed and not $Recipe.incorrect_ingredient:
			if $Recipe.check_if_in_recipe(body.ingredient_name):
				print('Collected a correct ingredient!')
				$Recipe.increase_collected_count(body.ingredient_name)
			else:
				print('Uh oh. Collected the wrong ingredient!')
				$Recipe.mark_incorrect_ingredient()
				
			body.queue_free()
			
		# TODO: Somehow set it so that the ingredients fall behind the player?
		# We can see that the collision is ignore
