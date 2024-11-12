extends StaticBody2D

signal recipe_sold

var activated: bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	activated = false

# Handles sale counter detection, activating a timer to represent the baking process.
func _on_area_2d_body_entered(_body: Node2D) -> void:
	print('ACTIVATED?: ', activated)
	if activated:
		print('Activated.')
		print('Selling...')
		# await get_tree().create_timer(0.25).timeout # Wait 0.25 seconds for selling process. 
		activated = false # Stops oven detection.
		# Emit signal that the recipe has been sold.
		recipe_sold.emit("Sold recipe!")
	
# Activates sale counter detection.	
func activate_sale_detection():
	print('DOES THIS WORK?')
	activated = true
