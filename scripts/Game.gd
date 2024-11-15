extends Node

@export var ingredient_scene: PackedScene
var coins_earned: int
var customers_served: int
var time_left: int

# Called when the node enters the scene tree for the first time.
func _ready():
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$NPC.generate_order()
	# NOTE: Temp function to display ingredients. Replace with $HUD.update_order_image(selected_order[0])
	$HUD.update_list_ingredients($NPC.selected_order[1][0], $NPC.selected_order[1][1], $NPC.selected_order[1][2])
	print($NPC.selected_order)
	coins_earned = 0
	customers_served = 0
	time_left = 120
	# Updates the coins and customers served.
	$HUD.update_coins(coins_earned)
	$HUD.update_customers_served(customers_served)
	
func reset_game():
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$NPC.generate_order()
	$HUD.reset_time_indicator()
	# NOTE: Temp function to display ingredients. Replace with $HUD.update_order_image(selected_order[0])
	$HUD.update_list_ingredients($NPC.selected_order[1][0], $NPC.selected_order[1][1], $NPC.selected_order[1][2])
	print($NPC.selected_order)
	coins_earned = 0
	customers_served = 0
	time_left = 120
	# Updates the coins and customers served.
	$HUD.update_coins(coins_earned)
	$HUD.update_customers_served(customers_served)
	
func _on_countdown_timer_timeout() -> void:
	time_left -= 1
	if time_left >= 0:
		$HUD.update_time_indicator(time_left)
	else:
		print('GAME OVER!')
		# NOTE: We would display a popup screen showing the coins earned, customers served, total coins earned, and total customers served.
		# NOTE: Then, we would change the scene back to either a) the main menu or b) the level menu.

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
				print('Collected a correct ingredient!')
				$NPC.increase_collected_count(body.ingredient_name)
				$HUD.update_ingredient_completion(body.ingredient_name)
			else:
				print('Uh oh. Collected the wrong ingredient!')
				$NPC.mark_incorrect_ingredient()
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
	$HUD.update_order_state("SOLD")
	$NPC.exit()
	coins_earned += 100
	customers_served += 1
	$HUD.update_coins(coins_earned)
	$HUD.update_customers_served(customers_served)
	$HUD.update_order_status(false)
	$NPC.generate_order()
	# NOTE: Temp function to display ingredients. Replace with $HUD.update_order_image(selected_order[0])
	$HUD.reset_ingredient_completion()
	$HUD.update_list_ingredients($NPC.selected_order[1][0], $NPC.selected_order[1][1], $NPC.selected_order[1][2])
	# $NPC.enter()
	print($NPC.selected_order)

# Activates ingredient collection again.	
func _on_trash_can_ingredient_discarded(test_string) -> void:
	print("Thrown ingredient!")
	$NPC.reset_incorrect_ingredient()

func _on_oven_display_baking_indicator() -> void:
	$HUD.update_order_state("BAKING")
