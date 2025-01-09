extends StaticBody2D

signal ingredient_discarded
signal display_throwing_indicator

var activated: bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	activated = false

# Handles trash detection, activating a timer to delay the player.
func _on_area_2d_body_entered(_body: Node2D) -> void:
	if activated:
		print('Activated.')
		print('Throwing...')
		display_throwing_indicator.emit()
		await get_tree().create_timer(0.25).timeout # Wait 0.5 seconds for throwing away trash. 
		activated = false # Stops oven detection.
		# Emit signal that the order has been sold.
		ingredient_discarded.emit("Thrown trash!")
	
# Activates sale counter detection.	
func activate_trash_detection():
	activated = true
