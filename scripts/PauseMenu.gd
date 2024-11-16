extends CanvasLayer

signal reset_game
signal resume_game
signal to_level_selection

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
