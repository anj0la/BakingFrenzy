extends StaticBody2D

signal something

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	# When the player comes into contact with the oven, we want to check whether the player can use the oven or not.
	# We need to check how much ingredients the player has collected already.
	# So we need to implement the Recipe scene
	something.emit(body)
