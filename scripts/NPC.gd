extends CharacterBody2D

signal bake_ingredients
signal order_completed

enum MovementStage {
	ENTERING,
	WAITING,
	EXITING,
	REENTERING,
}

const OFFSET: float = 100.0
@export var speed: float = 250.0
@export var recipe_manager: Resource

var movement_stage: MovementStage
var selected_order: Array
var screen_size: Vector2
var ingredient_count: int
var collected_ingredient_count: int
var completed_ingredient_collection: bool
var incorrect_ingredient: bool
var npc_at_counter: bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	movement_stage = MovementStage.ENTERING

# Called before physics step and in sync with physics server.
func _physics_process(delta):
	# Player is completing the NPC's order.
	if movement_stage == MovementStage.ENTERING:
		# Move to the left of the screen.
		move_and_collide(Vector2(-speed * delta, 0))
		velocity.x = -speed * delta
		if npc_at_counter:
			movement_stage = MovementStage.WAITING
	
	# NPC has reached the counter; Player is completing the NPC's order.
	elif movement_stage == MovementStage.WAITING:
		velocity.x = 0
		
	# Player has completed NPC's order.
	elif movement_stage == MovementStage.EXITING:
		# Move to the right of the screen.
		move_and_collide(Vector2(speed * delta, 0))
		velocity.x = speed * delta
		
		# NPC reenters the scene.
		if _is_off_screen():
			## NOTE: Change NPC image.
			movement_stage = MovementStage.ENTERING

	# Animate the NPC movement.
	if velocity.x != 0:
		$AnimatedSprite2D.flip_h = velocity.x < 0
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
		
# Generates a new order.
func generate_order():
	recipe_manager.reset_weights()
	selected_order = recipe_manager.select_recipe()
	recipe_manager.initialize_weights(selected_order)
	ingredient_count = selected_order[1].size()
	collected_ingredient_count = 0
	incorrect_ingredient = false 
	completed_ingredient_collection = false
	
# Returns the selected order. Used for UI display.
func get_selected_order() -> Array:
	return selected_order
	
# Increases the number of ingredients the player has collected.
func increase_collected_count(collided_ingredient: String) -> void:
	# Increment collected count.
	collected_ingredient_count += 1
		
	# Avoid seeing the collected ingredient again.
	recipe_manager.exclude_ingredient(collided_ingredient)
		
	# All ingredients have been collected and can be put into the oven.
	if collected_ingredient_count == ingredient_count:
		mark_required_ingredients_collected()
		bake_ingredients.emit()
		#print('Onto the Oven stage!')
			
# Checks if the collided ingredient is in the order.
func check_if_in_order(collided_ingredient: String) -> bool:
	if collided_ingredient in selected_order[1]: # selected_recipe[1] = ["ingredient_1", ... "ingredient_n"] 
		return true
	return false
	
# Sets the incorrect ingredient flag to true.
func mark_incorrect_ingredient(collided_ingredient: String) -> void:
	incorrect_ingredient = true
	# Collected ingredient is not seen again.
	recipe_manager.exclude_ingredient(collided_ingredient)

# Sets the incorrect ingredient flag to false.
func reset_incorrect_ingredient() -> void:
	incorrect_ingredient = false
	
# Sets the completed flag to true. MAY NOT BE NEEDED TBH.
func mark_required_ingredients_collected() -> void:
	completed_ingredient_collection = true
	
# Sends a signal that the order has been completed.
func mark_order_completed() -> void:
	# order_ready = true
	order_completed.emit("Ready to sell recipe!") # Signals that recipe is ready for collection.
	
# Moves the NPC into the screen.
func enter() -> void:
	movement_stage = MovementStage.ENTERING
	
# Moves the NPC out of the screen.
func exit() -> void:
	npc_at_counter = false # Make sure npc_at_counter is false when exiting.
	movement_stage = MovementStage.EXITING
	
# Checks if the NPC is out of the screen.
func _is_off_screen():
	return position.x > screen_size.x + OFFSET

# Handles collision with the SaleCounter to stop NPC from moving.
func _on_area_2d_body_entered(body: Node2D) -> void:
	print('NPC at counter: ', npc_at_counter)
	print('The body the NPC entered in is: ', body.name)
	if body.name == 'SaleCounter':
		npc_at_counter = true
		print('NPC at counter inside: ', npc_at_counter)
		# movement_stage = MovementStage.WAITING
		# Allow NPC to collide into Area2D again.
		$Area2D/CollisionShape2D.set_deferred("disabled", false)
