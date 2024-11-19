extends Resource

@export var recipes: Dictionary = {
	"purple": {"ingredients": ["red", "blue", "white"], "cost": 10},
	"cyan": {"ingredients": ["blue", "green", "white"], "cost": 12},
	"pink": {"ingredients": ["red", "yellow", "white"], "cost": 8}
}

@export var ingredient_weights: Dictionary = {
	"red": 1.0,
	"blue": 1.0,
	"green": 1.0,
	"yellow": 1.0,
	"white": 1.0
}

@export var default_weight: float = 1.0
@export var multiplier: float = 4.0

# NOTE: For testing purposes.
func _init() -> void:
	pass
	
# Selects a recupe from the recipes dictionary.
func select_recipe() -> Array:
	var rand_index = randi() % recipes.size()
	var rand_recipe_name = recipes.keys()[rand_index]
	var ingredients = recipes[rand_recipe_name]["ingredients"]
	var cost = recipes[rand_recipe_name]["cost"]
	return [rand_recipe_name, ingredients, cost] # selected_recipe[0] = recipe name, selected_recipe[1] = ["ingredient_1", ... "ingredient_n"], selected_recipe[2] = cost
	
# Initializes the weights, adding more importance (i.e., increasing the chance of selection) to the ingredients in the selected recipe.
func initialize_weights(selected_recipe: Array) -> void:
	for ingredient in ingredient_weights:
		if ingredient in selected_recipe[1]:
			ingredient_weights[ingredient] *= multiplier
	print('initialized weights: ', ingredient_weights)
	
# Resets the weights by setting them back to their default values.		
func reset_weights() -> void:
	for ingredient in ingredient_weights:
		ingredient_weights[ingredient] = default_weight
		
# Excludes the selected ingredient from being chosen again.
func exclude_ingredient(ingredient: String) -> void:
	ingredient_weights[ingredient] = 0.0
	
# Selects an ingredient from the weighted ingredient dictionary.	
func select_ingredient() -> String:
	# Get the total number of weights from ingredient_weights.
	var sum_weights: float = 0.0
	for ingredient in ingredient_weights:
		sum_weights += ingredient_weights[ingredient]
		
	# Get random number between default_weight (1.0) and sum_weights.
	var rand_num = randf_range(default_weight, sum_weights)
	
	# Return the random ingredient.
	for ingredient in ingredient_weights:
		if rand_num < ingredient_weights[ingredient]:
			return ingredient
		rand_num -= ingredient_weights[ingredient]
	
	return "An error has occured."
