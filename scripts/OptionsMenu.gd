extends Control

signal display_main_menu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false

func _on_close_button_pressed() -> void:
	visible = false
	display_main_menu.emit()
	
