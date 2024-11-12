extends Node2D

signal recipe_completed

var recipes: Dictionary = {"purple": ["red", "blue", "white"], "cyan": ["blue", "green", "white"], "pink": ["red", "yellow", "white"]}
var selected_recipe: Array
var seen_ingredients: Array
var ingredient_count: int
var collected_ingredient_count: int
var completed: bool
var incorrect_ingredient: bool
var recipe_ready: bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	seen_ingredients = Array() # Initalizes an empty array
	# initialize_recipe()
	
# Initalizes the recipe scene.
func initialize_recipe():
	selected_recipe = _select_recipe()
	seen_ingredients.clear() # Clear all seen ingredients
	ingredient_count = selected_recipe[1].size()
	collected_ingredient_count = 0
	completed = false
	incorrect_ingredient = false 
	print('Collected ingredient count: ', collected_ingredient_count)
	print('Ingredient count: ', ingredient_count)
	
func _select_recipe() -> Array:
	var rand_index = randi() % recipes.size()
	var rand_key = recipes.keys()[rand_index]
	return [rand_key, recipes[rand_key]] # selected_recipe[0] = recipe name, selected_recipe[1] = ["ingredient_1", ... "ingredient_n"] 
	
# Returns the selected recipe. Used for UI display.
func get_selected_recipe() -> Array:
	return selected_recipe
	
# Increases the number of ingredients the player has collected.
func increase_collected_count(collided_ingredient: String) -> void:
	if collided_ingredient not in seen_ingredients:
		collected_ingredient_count += 1
		seen_ingredients.append(collided_ingredient)
		
		# All ingredients have been collected and can be put into the oven.
		if collected_ingredient_count == ingredient_count:
			mark_recipe_completed()
			recipe_completed.emit(true)
			print('Onto the Oven stage!')
	else:
		print('Did not collect anything!\n')
		
	print('Seen ingredients: ', seen_ingredients)
	print('Collected ingredient count: ', collected_ingredient_count)
	
# Checks if the collided ingredient is in the recipe.
func check_if_in_recipe(collided_ingredient: String) -> bool:
	print('collided_ingredient: ', collided_ingredient)
	if collided_ingredient in selected_recipe[1]: # selected_recipe[1] = ["ingredient_1", ... "ingredient_n"] 
		return true
	return false
	
# Sets the incorrect ingredient flag to true.
func mark_incorrect_ingredient() -> void:
	incorrect_ingredient = true

# Sets the incorrect ingredient flag to false.
func reset_incorrect_ingredient() -> void:
	incorrect_ingredient = false
	
# Sets the completed flag to true.
func mark_recipe_completed() -> void:
	completed = true
