extends StaticBody2D

signal completed_baking
signal display_baking_indicator

var activated: bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	activated = false

# Handles oven detection, activating a timer to represent the baking process.
func _on_area_2d_body_entered(_body: Node2D) -> void:
	if activated:
		print('Activated.')
		print('Baking...')
		# Displays baking indicator for 0.5 seconds (TODO: implement progress bar)
		display_baking_indicator.emit()
		await get_tree().create_timer(0.5).timeout # Wait 0.5 seconds for baking process.
		activated = false # Stops oven detection.
		# Emit signal that the oven process is done.
		completed_baking.emit("Completed baking!")
		
# Activates oven detection.
func activate_oven_detection():
	activated = true
