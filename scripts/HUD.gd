extends CanvasLayer

signal pause_game

const BASE_RATE: int = 5
const FINAL_HOUR: int = 17 # 5 PM
const CLOSED_HOUR: int = 18 # 6 PM
# May store the following array into a CustomResource file.
const GOALS: Array = [{"name": "goal_coins", "target": 500}, {"name": "goal_customers", "target": 10}]
@export var seconds_per_in_game_hour: int = 12 # 6, 12, 18
var current_in_game_hour: float # 8.0, 8.1
var increment_interval: int # Define the interval at which to increment in-game time by 0.1 hours.

# Called when the node enters the scene tree for the first time.
func _ready() -> void: 
	increment_interval = seconds_per_in_game_hour / BASE_RATE # 6 / 5 = 
	print('increment interval: ', increment_interval)
	current_in_game_hour = 8.0 # Start at 8:00 AM.
	_display_time_in_hud(current_in_game_hour)
	# display_goal()
	update_order_status(false)
	update_order_state("")

# Updates the in-game time based on the remaining seconds.
# IMPORTANT NOTES
# The time goes from 8:00 AM to 6:00 PM daily (10 hours).
# 6 seconds = 1 hour (10 minutes per second): 10 hours in-game takes 60 seconds in real time.
# 12 seconds = 1 hour (10 minutes per 2 seconds): 10 hours in-game takes 120 seconds.
# 18 seconds = 1 hour (10 minutes per 3 seconds): 10 hours in-game takes 180 seconds.
func update_time_indicator(remaining_seconds: int) -> void:

	# Currently, hour changes every 24 seconds. 8.0 -> 8.5 -> 9.0.
	if remaining_seconds % increment_interval == 0:
		if current_in_game_hour - floor(current_in_game_hour) < 0.49: # 0.5 makes the following check false.
			current_in_game_hour += 0.1
		else:
			# Move to next full hour if we're at 0.5
			current_in_game_hour = floor(current_in_game_hour) + 1.0
	#elif remaining_seconds == 0:
	#	current_in_game_hour = CLOSED_HOUR
			
	# Display in HUD
	_display_time_in_hud(current_in_game_hour)
	_update_open_status(current_in_game_hour)

# Resets the time indicator.
func reset_time_indicator() -> void:
	current_in_game_hour = 8.0 # Start at 8:00 AM.
	_display_time_in_hud(current_in_game_hour)
	
# Updates the amount of coins the Player has collected.
func update_coins(coins: int) -> void:
	$MainControl/GameStatsContainer/Coins.text = str(coins)
	
# Updates the amount of customers the Player has served.
func update_customers_served(customers_served: int) -> void:
	$MainControl/GameStatsContainer/Customers.text = str(customers_served)
	
# Displays the objective(s) that a Player must achieve to complete the day (i.e., pass the level).
func display_goal(first_goal: Array) -> void:
	$MainControl/GoalsContainer/FirstGoal.text = "Earn " + str(first_goal[1]) + " coins"
		
# Updates order status, whether it is completed (green) or not (grey).
func update_order_status(completed: bool) -> void:
	if completed:
		$MainControl/OrderStatusContainer/CompletedStatus.add_theme_color_override("font_color", Color.LIME_GREEN)
	else:
		$MainControl/OrderStatusContainer/CompletedStatus.add_theme_color_override("font_color", Color.WEB_GRAY)

# Updates the order.
func update_order(recipe_name: String) -> void:
	var image_path = "res://art/rect_" + recipe_name + ".png" # TODO: change rect_ to actual order / recipe names.
	$MainControl/OrderStatusContainer/OrderImage.texture = load(image_path)

# Updates the order state.
func update_order_state(new_state: String) -> void:
	$MainControl/OrderStateContainer/OrderState.text = new_state
	await get_tree().create_timer(1.0).timeout
	$MainControl/OrderStateContainer/OrderState.text = ""
	
# Updates the open status.
func _update_open_status(in_game_hour: float) -> void:
	if int(in_game_hour) == FINAL_HOUR:
		# NOTE: We would add flashing animations to showcase that the store is closing soon.
		# NOTE: Use tween to animate 
		$MainControl/StatusTimeContainer/OpenStatus.text = "[center][color=orangered][pulse freq=1.0 color=##FFA500 ease=-2.0]CLOSING[/pulse]
[/color][/center]"
	elif int(in_game_hour) == CLOSED_HOUR:
		$MainControl/StatusTimeContainer/OpenStatus.text = "[center][color=black]CLOSED[/color][/center]"
		
# Displays the in-game time on the HUD.
func _display_time_in_hud(in_game_hour: float) -> void:
	# Get hours, minutes and AM/PM indicator.
	var hours = int(in_game_hour)
	var minutes = round((in_game_hour - floor(in_game_hour)) * 100)
	var am_pm_indicator = " AM" if hours < 12 else " PM"
	
	# Convert hours to 12-hour format for display.
	var display_hour = hours if hours <= 12 else hours - 12
	if display_hour == 0:
		display_hour = 12  # Handle 12 AM/PM edge case
	
	# Format minutes with padding.
	var display_minutes = str(minutes).pad_zeros(2)
	var in_game_hour_str = str(display_hour) + ":" + display_minutes + am_pm_indicator
	# print(str(display_hour) + ":" + display_minutes + am_pm_indicator)
	$MainControl/StatusTimeContainer/TimeIndicator.text = in_game_hour_str
	
# Updates the list of ingredients. TODO: Replace with order image.
func update_list_ingredients(first_name: String, second_name: String, third_name: String) -> void:
	$MainControl/OrderStatusContainer/IngredientsTempContainer/FirstIngredientName.text = first_name
	$MainControl/OrderStatusContainer/IngredientsTempContainer/SecondIngredientName.text = second_name
	$MainControl/OrderStatusContainer/IngredientsTempContainer/ThirdIngredientName.text = third_name

func update_ingredient_completion(ingredient_name: String) -> void:
	if $MainControl/OrderStatusContainer/IngredientsTempContainer/FirstIngredientName.text == ingredient_name:
		$MainControl/OrderStatusContainer/IngredientsTempContainer/FirstIngredientName.add_theme_color_override("font_color", Color.LIME_GREEN)
	elif $MainControl/OrderStatusContainer/IngredientsTempContainer/SecondIngredientName.text == ingredient_name:
		$MainControl/OrderStatusContainer/IngredientsTempContainer/SecondIngredientName.add_theme_color_override("font_color", Color.LIME_GREEN)
	else:
		$MainControl/OrderStatusContainer/IngredientsTempContainer/ThirdIngredientName.add_theme_color_override("font_color", Color.LIME_GREEN)

func reset_ingredient_completion() -> void:
	$MainControl/OrderStatusContainer/IngredientsTempContainer/FirstIngredientName.add_theme_color_override("font_color", Color.BLACK)
	$MainControl/OrderStatusContainer/IngredientsTempContainer/SecondIngredientName.add_theme_color_override("font_color", Color.BLACK)
	$MainControl/OrderStatusContainer/IngredientsTempContainer/ThirdIngredientName.add_theme_color_override("font_color", Color.BLACK)
		

# Generates a goal.
# To do so, need to have goals separated into 2 categories: goal_coins & goal_customers
# Take a goal from the list of goals. The goals is of the format: {name: goal_coins, target: 500}, {name: goal_customers, target: 10}
# if name == goal_coins , then string is Earn ____ coins with the coins image later.
# if name == goal_customers, then string is Serve ______ customers with customers image later.
func _generate_goal() -> String:
	var rand_index = randi() % GOALS.size()
	var goal = GOALS[rand_index]
	
	if goal.name == "goal_coins":
		return "Earn " + str(goal.target) + " coins"
	# Then goal.name == goal_customers.
	else:
		return "Serve " + str(goal.target) + " customers"
		
# Emits signal to pause the game.
func _on_menu_button_pressed() -> void:
	pause_game.emit()
