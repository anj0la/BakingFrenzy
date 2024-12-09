extends Resource

# Separate recipe dictionaries
@export var kneaded_recipes: Dictionary = {
	"cinnamon_buns": {"ingredients": ["cinnamon", "sugar", "dough"], "cost": 10},
	"chocolate_croissants": {"ingredients": ["butter", "dough", "chocolate"], "cost": 12},
	"butter_croissants": {"ingredients": ["butter", "dough", "sugar"], "cost": 10},
	"honey_glazed_rolls": {"ingredients": ["honey", "dough", "butter"], "cost": 10},
	"jelly_donut": {"ingredients": ["jam", "dough", "sugar"], "cost": 9}
}

@export var chilled_recipes: Dictionary = {
	"cheesecake": {"ingredients": ["cream_cheese", "sugar", "graham_crackers"], "cost": 15},
	"vanilla_cupcakes": {"ingredients": ["flour", "sugar", "vanilla_extract"], "cost": 10},
	"chocolate_cupcakes": {"ingredients": ["flour", "cocoa_powder", "sugar"], "cost": 12},
	"brownies": {"ingredients": ["cocoa_powder", "sugar", "egg"], "cost": 13},
	"peanut_butter_fudge": {"ingredients": ["peanut_butter", "sugar", "chocolate"], "cost": 14}
}

@export var general_recipes: Dictionary = {
	"banana_bread": {"ingredients": ["banana", "flour", "sugar"], "cost": 11},
	"chocolate_chip_cookies": {"ingredients": ["chocolate_chips", "sugar", "flour"], "cost": 10},
	"muffins": {"ingredients": ["flour", "sugar", "butter"], "cost": 9},
	"pancakes": {"ingredients": ["flour", "egg", "milk"], "cost": 8},
	"waffles": {"ingredients": ["flour", "egg", "butter"], "cost": 10}
}

# Combined recipes dictionary (useful for random selection)
var recipes: Dictionary

@export var ingredient_weights: Dictionary = {
	"cinnamon": 1.0,
	"sugar": 1.0,
	"dough": 1.0,
	"butter": 1.0,
	"chocolate": 1.0,
	"honey": 1.0,
	"jam": 1.0,
	"cream_cheese": 1.0,
	"graham_crackers": 1.0,
	"flour": 1.0,
	"vanilla_extract": 1.0,
	"cocoa_powder": 1.0,
	"egg": 1.0,
	"peanut_butter": 1.0,
	"banana": 1.0,
	"chocolate_chips": 1.0,
	"milk": 1.0
}

@export var default_weight: float = 1.0
@export var multiplier: float = 4.0

# NOTE: For testing purposes.
# Merges all recipe categories into one recipe dictionary.
func _init() -> void:
	recipes.merge(kneaded_recipes)
	recipes.merge(chilled_recipes)
	recipes.merge(general_recipes)
	print(recipes)
	
# Selects a recipe from the recipes dictionary.
func select_recipe() -> Array:
	var rand_index = randi() % recipes.size()
	var rand_recipe_name = recipes.keys()[rand_index]
	var ingredients = recipes[rand_recipe_name]["ingredients"]
	var cost = recipes[rand_recipe_name]["cost"]
	return [rand_recipe_name, ingredients, cost] # selected_recipe[0] = recipe name, selected_recipe[1] = ["ingredient_1", ... "ingredient_n"], selected_recipe[2] = cost
	
# Gets the recipe category of the specified recipe name.
func get_recipe_category(recipe_name: String) -> String:
	if recipe_name in kneaded_recipes:
		return "kneaded_recipes"
	elif recipe_name in chilled_recipes:
		return "chilled_recipes"
	elif recipe_name in general_recipes:
		return "general_recipes"
	else:
		return "The recipe does not exist in any of the following categories: Kneaded, Chilled and General."
		
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
