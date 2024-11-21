extends Node

const SINGLE_CUSTOMER: int = 1
@export var ingredient_scene: PackedScene
@export var game_stats: Resource
var elapsed_time: float

# Called when the node enters the scene tree for the first time.
func _ready():
	# Place player at starting position.
	$Player.start($StartPosition.position)
	
	# Generate an order for the NPC.
	$NPC.generate_order()
	
	# Update list of ingredients.
	$HUD.update_list_ingredients($NPC.selected_order[1][0], $NPC.selected_order[1][1], $NPC.selected_order[1][2]) # NOTE: Temp function to display ingredients.
	
	# Generate the goal for the level and thresholds to get three stars.
	game_stats.generate_goal()
	game_stats.setup_level_goal()
	
	# Display the goal.
	$HUD.display_goal(game_stats.selected_goal)
		
	# Set elasped time.
	elapsed_time = 0.0
	
	# Update the coins and customers served.
	$HUD.update_coins(game_stats.current_level_coins)
	$HUD.update_customers_served(game_stats.current_level_customers_served)
	
	# Start the game timer and ingredient spawn timer.
	$StartTimer.start()
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Check if player has passed threshold every frame.
	game_stats.update_current_level_stars()
	
	# Updates time in-game every second.
	elapsed_time += delta
	if elapsed_time >= 1.0:
		$HUD.update_time_indicator(int($CountdownTimer.time_left))
		elapsed_time = 0.0
	
# Handles input events for pausing the game.
func _input(event):
	if event.is_action_pressed("pause_game"):
		_toggle_pause_menu()	
	
# Resets the game.
func reset_game():
	# Place player at starting position.
	$Player.start($StartPosition.position)
	
	# Free any active ingredients.
	get_tree().call_group("active_ingredient", "queue_free")
	
	# Generate an order for the NPC.
	$NPC.generate_order()
	
	# Reset time indicator and list of ingredients.
	$HUD.reset_time_indicator()
	$HUD.update_list_ingredients($NPC.selected_order[1][0], $NPC.selected_order[1][1], $NPC.selected_order[1][2]) # NOTE: Temp function to display ingredients.
	
	# Reset level stats.
	game_stats.reset_level_stats()
	
	print($NPC.selected_order)
	
	# Update the coins and customers served.
	$HUD.update_coins(game_stats.current_level_coins)
	$HUD.update_customers_served(game_stats.current_level_customers_served)
	
	# Start the game timer and ingredient spawn timer.
	$StartTimer.start()
	
# Ends the game.
func _on_countdown_timer_timeout() -> void:
	print("GAME OVER!")
	
	# Stop spawning ingredients and clear all active ingredients from the scene.
	$IngredientTimer.stop()
	get_tree().call_group("active_ingredient", "queue_free")
	
	# Stop player movement from being processed.
	$Player.stop_movement()
	
	# Display game over menu.
	$GameOverMenu.display_game_over_menu(game_stats.current_level, game_stats.current_level_stars, game_stats.current_level_coins, game_stats.current_level_customers_served)
	
	# Unlock next level and save stats.
	game_stats.complete_level()
	game_stats.save_game_stats()
	
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
	
# Starts all necessary timers for the Game scene.
func _on_start_timer_timeout() -> void:
	$IngredientTimer.start()
	$CountdownTimer.start()
	# print('Started ingredient timer.')

# Called every time an object enters the player's body.
func _on_player_hit(body: Node2D) -> void:
	# Check if active collided ingredient is a part of the selected recipe.
	if body.is_in_group("active_ingredient"):
		# print(body.ingredient_name)
		#print('Recipe completed: ', $Recipe.completed)
		#print('Incorrect ingredient: ', $Recipe.incorrect_ingredient)
		# Ignore collision detection if the recipe has been completed or the player has collected the wrong ingredient.
		if not $NPC.completed_ingredient_collection and not $NPC.incorrect_ingredient:
			if $NPC.check_if_in_order(body.ingredient_name):
				# print('Collected a correct ingredient!')
				$NPC.increase_collected_count(body.ingredient_name)
				$HUD.update_ingredient_completion(body.ingredient_name)
			else:
				# print('Uh oh. Collected the wrong ingredient!')
				$NPC.mark_incorrect_ingredient(body.ingredient_name)
				# Activate trash detection to throw away the wrong ingredient.
				$TrashCan.activate_trash_detection()
			
			# Remove the ingredient from the scene
			body.queue_free()	

# Activates oven detection to bake the ingredients.
func _on_npc_bake_ingredients() -> void:
	$HUD.update_order_status(true)
	$Oven.activate_oven_detection()
	
# Activates sale counter detection to sell the order.
func _on_npc_order_completed(test_string) -> void:
	print(test_string)
	$SaleCounter.activate_sale_detection()

# Called once the completed baking signal has been emitted from the Oven scene.
func _on_oven_completed_baking(test_string) -> void:
	print(test_string)
	# Mark order as completed (emits the order completed signal).
	$NPC.mark_order_completed()

# Called once the order has been sold.
func _on_sale_counter_order_sold(test_string) -> void:
	print(test_string)
	
	# Update order state to SOLD.
	$HUD.update_order_state("SOLD")
	
	# Remove NPC from screen.
	$NPC.exit()

	# Update and display coins earned and customers served.
	game_stats.update_level_coins_and_customers_served($NPC.selected_order[2], SINGLE_CUSTOMER)
	$HUD.update_coins(game_stats.current_level_coins)
	$HUD.update_customers_served(game_stats.current_level_customers_served)
	
	# Remove order state from game screen.
	$HUD.update_order_status(false)
	
	# Generate new order.
	$NPC.generate_order()
	$HUD.reset_ingredient_completion()
	
	# TODO: Replace with ingredient pictures.
	$HUD.update_list_ingredients($NPC.selected_order[1][0], $NPC.selected_order[1][1], $NPC.selected_order[1][2])
	print($NPC.selected_order)

# Activates ingredient collection again.	
func _on_trash_can_ingredient_discarded(test_string) -> void:
	# print("Thrown ingredient!")
	$NPC.reset_incorrect_ingredient()

# Displays to the game screen that the ingredients are baking.
func _on_oven_display_baking_indicator() -> void:
	$HUD.update_order_state("BAKING")

# Displays to the game screen that the incorrect ingredients is being thrown out.
func _on_trash_can_display_throwing_indicator() -> void:
	$HUD.update_order_state("THROWING")
	
# Toggles the pause menu.
func _toggle_pause_menu():
	if $PauseMenu.visible:
		$PauseMenu.hide()
		get_tree().paused = false
	else:
		$PauseMenu.show()
		get_tree().paused = true

# Toggles the pause menu through pressing the Menu button.
func _on_hud_pause_game() -> void:
	_toggle_pause_menu()
	
# Restarts the game from the beginning (from the paused menu).
func _on_pause_menu_reset_game() -> void:
	$PauseMenu.hide()
	reset_game()
	get_tree().paused = false

# Resumes the game from the paused menu.
func _on_pause_menu_resume_game() -> void:
	$PauseMenu.hide()
	get_tree().paused = false

# Restarts the game from the beginning (from game over menu).
func _on_game_over_menu_reset_game() -> void:
	reset_game()
