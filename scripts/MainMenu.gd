extends Control

@export var game_stats: Resource

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# game_stats,delete_game_stats()
	# Loads player game stats.
	game_stats.load_game_stats()
	# Testing
	print("current level: ", game_stats.current_level)
	#print("total coins: ", game_stats.total_coins)
	#print("total customers served: ", game_stats.total_customers_served)
	#print("total stars: ", game_stats.total_stars)
	#print("level info: ", game_stats.level_info)

# Remves start menu options, allowing the player to enter the level selection menu, customize their shop and view their inventory.
func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/BakeryHub.tscn")

# Allows player to toggle options in the game.
func _on_options_button_pressed() -> void:
	$MenuOptionsContainer.visible = false
	$OptionsMenu.visible = true

# Quits the game.
func _on_quit_button_pressed() -> void:
	get_tree().quit()

# Displays the main menu again.
func _on_options_menu_display_main_menu() -> void:
	$MenuOptionsContainer.visible = true
