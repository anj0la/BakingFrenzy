extends CanvasLayer

signal pause_game

@export var seconds_per_in_game_hour: int = 12 # 6, 12, 18

const MAX_COINS: int = 99999
const MAX_CUSTOMERS: int = 999
const BASE_RATE: int = 5
const FINAL_HOUR: int = 17 # 5 PM
const CLOSED_HOUR: int = 18 # 6 PM

var current_in_game_hour: float # 8.0, 8.1
var increment_interval: int # Define the interval at which to increment in-game time by 0.1 hours.
var ingredient_names: Array

# Called when the node enters the scene tree for the first time.
func _ready() -> void: 
	increment_interval = seconds_per_in_game_hour / BASE_RATE
	print('increment interval: ', increment_interval)
	current_in_game_hour = 8.0 # Start at 8:00 AM.
	_display_time_in_hud(current_in_game_hour)
	update_order_status(false)

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
	if coins > MAX_COINS:
		$MainControl/GameStatsRect/GameStatsContainer/CoinsContainer/Coins.text = str(MAX_COINS) + "+"
	else:
		$MainControl/GameStatsRect/GameStatsContainer/CoinsContainer/Coins.text = str(coins)
	
# Updates the amount of customers the Player has served.
func update_customers_served(customers_served: int) -> void:
	if customers_served > 999:
		$MainControl/GameStatsRect/GameStatsContainer/CustomersContainer/Customers.text = str(MAX_CUSTOMERS) + "+"
	else:	
		$MainControl/GameStatsRect/GameStatsContainer/CustomersContainer/Customers.text = str(customers_served)
	
# Displays the objective that a player must achieve to complete the day (i.e., pass the level).
func display_goal(first_goal: Array) -> void:
	$MainControl/GoalRect/GoalsContainer/GoalLabel.text = "Goal: " + str(first_goal[1])
	
func update_goal_status() -> void:
	pass
		
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
	$MainControl/OrderStateRect.visible = true
	$MainControl/OrderStateRect/OrderState.text = new_state
	await get_tree().create_timer(1.0).timeout
	$MainControl/OrderStateRect/OrderState.text = ""
	$MainControl/OrderStateRect.visible = false
	
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
	var first_image_path = "res://art/" + first_name + ".png"
	var second_image_path = "res://art/" + second_name + ".png"
	var third_image_path = "res://art/" + third_name + ".png"
	
	ingredient_names = [first_name, second_name, third_name]

	$MainControl/OrderStatusContainer/IngredientsTempContainer/FirstIngredientRect.texture = load(first_image_path)
	$MainControl/OrderStatusContainer/IngredientsTempContainer/SecondIngredientRect.texture = load(second_image_path)
	$MainControl/OrderStatusContainer/IngredientsTempContainer/ThirdIngredientRect.texture = load(third_image_path)
	
	# Make collected rect invisible.
	$MainControl/OrderStatusContainer/IngredientsTempContainer/FirstIngredientRect/CollectedRect.visible = false
	$MainControl/OrderStatusContainer/IngredientsTempContainer/SecondIngredientRect/CollectedRect.visible = false
	$MainControl/OrderStatusContainer/IngredientsTempContainer/ThirdIngredientRect/CollectedRect.visible = false
	
func update_recipe_rect(recipe_name: String) -> void:
	var image_path = "res://art/" + recipe_name + ".png"
	var grey_arrow_image_path = "res://art/grey_arrow.png"
	$MainControl/OrderStatusContainer/IngredientsTempContainer/RecipeRect.texture = load(image_path)
	
	# Make collected rect invisible.
	$MainControl/OrderStatusContainer/IngredientsTempContainer/RecipeRect/CollectedRect.visible = false
	
	# Change colour of arrow to grey.
	$MainControl/OrderStatusContainer/IngredientsTempContainer/ArrowRect.texture = load(grey_arrow_image_path)

func update_ingredient_completion(ingredient_name: String) -> void:
	if ingredient_name == ingredient_names[0]:
		$MainControl/OrderStatusContainer/IngredientsTempContainer/FirstIngredientRect/CollectedRect.texture = load("res://art/green_checkmark.png")
		$MainControl/OrderStatusContainer/IngredientsTempContainer/FirstIngredientRect/CollectedRect.visible = true
	elif ingredient_name == ingredient_names[1]:
		$MainControl/OrderStatusContainer/IngredientsTempContainer/SecondIngredientRect/CollectedRect.texture = load("res://art/green_checkmark.png")
		$MainControl/OrderStatusContainer/IngredientsTempContainer/SecondIngredientRect/CollectedRect.visible = true
	else:
		$MainControl/OrderStatusContainer/IngredientsTempContainer/ThirdIngredientRect/CollectedRect.texture = load("res://art/green_checkmark.png")
		$MainControl/OrderStatusContainer/IngredientsTempContainer/ThirdIngredientRect/CollectedRect.visible = true
		
	# Update the green arrow if all collected rects are visible. 
	if _check_if_all_ingredients_collected():
		_update_arrow_rect()
		
func update_wrong_ingredient() -> void:
	if $MainControl/OrderStatusContainer/IngredientsTempContainer/FirstIngredientRect/CollectedRect.visible == false:
		$MainControl/OrderStatusContainer/IngredientsTempContainer/FirstIngredientRect/CollectedRect.texture = load("res://art/red_x.png")
		$MainControl/OrderStatusContainer/IngredientsTempContainer/FirstIngredientRect/CollectedRect.visible = true
	elif $MainControl/OrderStatusContainer/IngredientsTempContainer/SecondIngredientRect/CollectedRect.visible == false:
		$MainControl/OrderStatusContainer/IngredientsTempContainer/SecondIngredientRect/CollectedRect.texture = load("res://art/red_x.png")
		$MainControl/OrderStatusContainer/IngredientsTempContainer/SecondIngredientRect/CollectedRect.visible = true
	else:
		$MainControl/OrderStatusContainer/IngredientsTempContainer/ThirdIngredientRect/CollectedRect.texture = load("res://art/red_x.png")
		$MainControl/OrderStatusContainer/IngredientsTempContainer/ThirdIngredientRect/CollectedRect.visible = true

func remove_wrong_ingredient() -> void:
	if $MainControl/OrderStatusContainer/IngredientsTempContainer/FirstIngredientRect/CollectedRect.visible == true:
		if $MainControl/OrderStatusContainer/IngredientsTempContainer/FirstIngredientRect/CollectedRect.texture.resource_path == "res://art/red_x.png":
			$MainControl/OrderStatusContainer/IngredientsTempContainer/FirstIngredientRect/CollectedRect.visible = false
	elif $MainControl/OrderStatusContainer/IngredientsTempContainer/SecondIngredientRect/CollectedRect.visible == true:
		if $MainControl/OrderStatusContainer/IngredientsTempContainer/SecondIngredientRect/CollectedRect.texture.resource_path == "res://art/red_x.png":
			$MainControl/OrderStatusContainer/IngredientsTempContainer/SecondIngredientRect/CollectedRect.visible = false
	else:
		if $MainControl/OrderStatusContainer/IngredientsTempContainer/ThirdIngredientRect/CollectedRect.texture.resource_path == "res://art/red_x.png":
			$MainControl/OrderStatusContainer/IngredientsTempContainer/ThirdIngredientRect/CollectedRect.visible = false
			
func reset_ingredient_completion() -> void:
	$MainControl/OrderStatusContainer/IngredientsTempContainer/FirstIngredientRect/CollectedRect.visible = false
	$MainControl/OrderStatusContainer/IngredientsTempContainer/SecondIngredientRect/CollectedRect.visible = false
	$MainControl/OrderStatusContainer/IngredientsTempContainer/ThirdIngredientRect/CollectedRect.visible = false
	$MainControl/OrderStatusContainer/IngredientsTempContainer/RecipeRect/CollectedRect.visible = false
	
func update_recipe_completion() -> void:
	$MainControl/OrderStatusContainer/IngredientsTempContainer/RecipeRect/CollectedRect.visible = true
	
func _check_if_all_ingredients_collected() -> bool:
	if $MainControl/OrderStatusContainer/IngredientsTempContainer/FirstIngredientRect/CollectedRect.visible == true \
	and $MainControl/OrderStatusContainer/IngredientsTempContainer/SecondIngredientRect/CollectedRect.visible == true \
	and $MainControl/OrderStatusContainer/IngredientsTempContainer/ThirdIngredientRect/CollectedRect.visible == true:
		return true
	return false
	
func _update_arrow_rect() -> void:
	var green_arrow_image_path = "res://art/green_arrow.png"
	
	# Change colour of arrow to green.
	$MainControl/OrderStatusContainer/IngredientsTempContainer/ArrowRect.texture = load(green_arrow_image_path)
		
# Emits signal to pause the game.
func _on_menu_button_pressed() -> void:
	pause_game.emit()
