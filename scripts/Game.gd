extends Node

@export var ingredient_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$Recipe.generate_recipe()
	print($Recipe.selected_recipe)

# Creates a new ingredient every time the timer is completed.
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
	
# Starts all necessary timers for the game.
func _on_start_timer_timeout() -> void:
	$IngredientTimer.start()
	# print('Started ingredient timer.')

# Called every time an object enters the player's body.
func _on_player_hit(body: Node2D) -> void:
	# Check if active collided ingredient is a part of the selected recipe.
	if body.is_in_group("active_ingredient"):
		# print(body.ingredient_name)
		#print('Recipe completed: ', $Recipe.completed)
		#print('Incorrect ingredient: ', $Recipe.incorrect_ingredient)
		# Ignore collision detection if the recipe has been completed or the player has collected the wrong ingredient.
		if not $Recipe.completed and not $Recipe.incorrect_ingredient:
			if $Recipe.check_if_in_recipe(body.ingredient_name):
				print('Collected a correct ingredient!')
				$Recipe.increase_collected_count(body.ingredient_name)
			else:
				print('Uh oh. Collected the wrong ingredient!')
				$Recipe.mark_incorrect_ingredient()
			
			# Remove the ingredient from the scene
			body.queue_free()

func _on_recipe_completed() -> void:
	$Oven.activate_oven_detection()

# Called once the recipe is ready to be sold.
func _on_recipe_ready_to_be_sold(test_string) -> void:
	print(test_string)
	# Sell recipe.
	$SaleCounter.activate_sale_detection()
	# In the area2d detection, we deactivate the sale counter.
	pass # Replace with function body.

# Called once the completed baking signal has been emitted from the Oven scene.
func _on_oven_completed_baking(test_string) -> void:
	print(test_string)
	# Mark recipe ready to be sold.
	$Recipe.mark_recipe_ready()

func _on_sale_counter_recipe_sold(test_string) -> void:
	print(test_string)
	# Wait for recipe to be sold from SaleCounter.
	# Once sold, generate a new recipe.
	# Generate a new recipe (resets all flags).
	$Recipe.generate_recipe()
	print($Recipe.selected_recipe)

# IT ACTUALLY WORKS! WOAH WOAH WOAH!!!!!
