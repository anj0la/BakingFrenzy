extends Node2D

@export var path_max_length = 600
var recipes = {"purple": ["red", "blue", "white"], "cyan": ["blue", "green", "white"], "pink": ["red", "yellow", "white"]}
const V_OFFSET = 500
var selected_recipe
var ingredient_count

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	selected_recipe = _select_recipe()
	ingredient_count = selected_recipe.values()[0].size() # .values() gives us a 2D list consisting of one element (i.e., [["egg", "flour"]], which is why we use [0] to get the actual list
	#_create_path()
	_create_ingredient_spawn_locations()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _select_recipe() -> Dictionary:
	var rand_index = randi() % recipes.size()
	var rand_key = recipes.keys()[rand_index]
	return {rand_key: recipes[rand_key]}

func _update_selected_recipe(updated_recipe: Dictionary) -> void:
	selected_recipe = updated_recipe
	

# Figure out how to add a path dynamically.
	

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	

func _create_path() -> void:
	var curve = $RecipePath.curve
	var start_pos = Vector2(0, 150)
	var end_pos = Vector2(0, 600)
	
	# Clear existing points (if there are any)
	curve.clear_points()
	
	# Calculate spacing between each point
	var spacing = (end_pos - start_pos) / (ingredient_count - 1)
	
	# Add points in a straight line
	for i in range(ingredient_count):
		var point_pos
		if i == 0:
			print(i)
			point_pos = start_pos + spacing
		else:
			point_pos = start_pos + spacing + Vector2(0, i)
		
		curve.add_point(point_pos)

# Create PathFollow2D nodes with even spacing based on ingredient count.
func _create_ingredient_spawn_locations() -> void:
	print(ingredient_count)
	# Calculate spacing based on number of ingredients.
	var ingredient_spacing = path_max_length / (ingredient_count + 1) 
	for i in range(ingredient_count):
		print('count: ', i)
		# Create a new spawn location.
		var ingredient_spawn_location = PathFollow2D.new()
		
		# Apply horizontial and vertical offset for even spacing.
		#ingredient_spawn_location.h_offset = ingredient_spacing * (i + 1)
		#ingredient_spawn_location.v_offset = V_OFFSET
		
		# Add the spawn location to the Path2D node.
		$RecipePath.add_child(ingredient_spawn_location)
		
		# Create a new Sprite 2D node.
		var ingredient_sprite = Sprite2D.new()
		
		# Change the texture to the specific ingredient in the recipe.
		var ingredient_name = selected_recipe.values()[0][i]
		var image_path = "res://art/rect_" + ingredient_name + ".png"
		ingredient_sprite.texture = load(image_path)
		
		# Add the ingredient sprite to the spawn location.
		ingredient_sprite.position = ingredient_spawn_location.position
		
		# Create a new instance of the Ingredient scene.
		#var ingredient = ingredient_scene.instantiate()
		
		# Change texture to the specific ingredient in the recipe.
		#var ingredient_name = selected_recipe.values()[0][i]
		#ingredient.set_texture(ingredient_name)
		
		# Add ingredient scene to each spawn location.
		#ingredient.position = ingredient_spawn_location.position
		
		# Spawn the ingredient by adding it to the Recipe scene.
		add_child(ingredient_sprite)
