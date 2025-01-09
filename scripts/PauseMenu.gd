extends CanvasLayer

signal reset_game
signal resume_game
signal to_home

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()

# Restarts the game.
func _on_restart_button_pressed() -> void:
	print("Resetting game.")
	reset_game.emit()
	
# Resumes the game.
func _on_resume_button_pressed() -> void:
	print("Resuming game.")
	resume_game.emit()
	
# Changes the scene to the Main Menu scene.
func _on_home_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
