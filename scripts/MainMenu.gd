extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Remves main menu options, allowing the player to enter the level selection menu, customize their shop and view their inventory.
func _on_play_button_pressed() -> void:
	$MainControl/MenuOptionsContainer.visible = false
	$MainControl/OpenShopButton.visible = true

# Allows player to toggle options in the game.
func _on_options_button_pressed() -> void:
	print("Toggle sound / audio options.")

# Quits the game.
func _on_quit_button_pressed() -> void:
	get_tree().quit()
