extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
# Closes the game. NOTE: Save stats always before closing the game.
func _on_close_button_pressed() -> void:
	get_tree().quit()

# Displays the Level Selection Menu.
func _on_level_selection_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/LevelSelectionMenu.tscn")
