extends StaticBody2D

signal order_sold

var activated: bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	activated = false

# Handles sale counter detection, activating a timer to represent the baking process.
func _on_area_2d_body_entered(_body: Node2D) -> void:
	if activated:
		print('Activated.')
		print('Selling...')
		# await get_tree().create_timer(0.25).timeout # Wait 0.25 seconds for selling process. 
		activated = false # Stops oven detection.
		# Emit signal that the order has been sold.
		order_sold.emit("Sold order!")
	
# Activates sale counter detection.	
func activate_sale_detection():
	activated = true
