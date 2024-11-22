extends Control

@export var game_stats: Resource

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$MenuStatsContainer/Coins.text = str(game_stats.total_coins)
	
# Closes the game. NOTE: Save stats always before closing the game.
func _on_close_button_pressed() -> void:
	game_stats.save_game_stats()
	get_tree().quit()

# Displays the Level Selection Menu.
func _on_level_selection_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/LevelSelectionMenu.tscn")

# Takes player to Upgrade Hub where they can upgrade their kitchen items.
func _on_upgrade_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/UpgradeHub.tscn")
