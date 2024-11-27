extends CanvasLayer

signal reset_game

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	# hide()
	
# Displays the game over menu.
func display_game_over_menu(day: int, stars_earned: int, coins_earned: int, customers_served: int) -> void:
	show()
	_display_day_completed(day)
	_display_stars_earned(stars_earned)
	_display_coins_earned(coins_earned)
	_display_customers_served(customers_served)
	
# Hides the game over menu.
func remove_game_over_menu() -> void:
	hide()

# Sends player back to home screen (main menu).	
func _on_home_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/BakeryHub.tscn")

# Restarts the game.
func _on_restart_button_pressed() -> void:
	reset_game.emit()
	
# Sends player back to level selection menu.
func _on_level_selection_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/LevelSelectionMenu.tscn")

# Displays the day (i.e., level) the player has completed.
func _display_day_completed(day: int) -> void:
	$MainControl/MenuContainer/DayCompleted.text = "DAY " + str(day)

# Displays the number of stars the player has earned.
func _display_stars_earned(stars_earned: int) -> void:
	var image_path = "res://art/" + str(stars_earned) + "_stars.png"
	$MainControl/MenuContainer/StarsEarned.texture = load(image_path)
	
# Displays the total coins earned.
func _display_coins_earned(coins_earned: int) -> void:
	$MainControl/MenuContainer/GameStatsContainer/CoinsContainer/CoinsEarned.text = str(coins_earned)

# Displays the total customers served.
func _display_customers_served(customers_served: int) -> void:
	$MainControl/MenuContainer/GameStatsContainer/CustomersContainer/CustomersServed.text = str(customers_served)
	
