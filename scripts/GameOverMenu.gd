extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	
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

# Displays the day (i.e., level) the player has completed.
func _display_day_completed(day: int) -> void:
	$MainControl/MenuContainer/DayCompleted.text = "DAY " + str(day)

# Displays the number of stars the player has earned.
func _display_stars_earned(stars_earned: int) -> void:
	var image_path = "res://art/" + str(stars_earned) + "_stars.png"
	$MainControl/MenuContainer/StarsEarned.texture = load("res://art/three_stars.png")
	
# Displays the total coins earned.
func _display_coins_earned(coins_earned: int) -> void:
	$MainControl/MenuContainer/GameStatsContainer/CoinsContainer/CoinsEarned.text = str(coins_earned)

# Displays the total customers served.
func _display_customers_served(customers_served: int) -> void:
	$MainControl/MenuContainer/GameStatsContainer/CustomersContainer/CustomersServed.text = str(customers_served)
	
