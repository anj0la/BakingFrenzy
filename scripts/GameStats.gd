extends Resource

# Upgrade-related constants
const UPGRADE_COST_MULTIPLIER: float = 1.2

# Level-related stats
var furthest_level: int = 1
var current_level: int = 1
var current_level_coins: int = 0
var current_level_customers_served: int = 0
var current_level_stars: int = 0

var trash_reduction_level: int = 0

# Global stats
var total_coins: int = 0
var total_customers_served: int = 0
var total_stars: int = 0

# Per-level stats
var selected_goal: Array = []
var star_thresholds: Array = []

# Level information
var level_info: Dictionary = {
	"day_1" : {
		"locked": false,
		"stars_collected": 0,
		"goals": {"coins_collected": 50}
	},
	"day_2" : {
		"locked": true,
		"stars_collected": 0,
		"goals": {"coins_collected": 75}
	},
	"day_3" : {
		"locked": true,
		"stars_collected": 0,
		"goals": {"coins_collected": 100}
	},
	"day_4" : {
		"locked": true,
		"stars_collected": 0,
		"goals": {"coins_collected": 125}
	},
	"day_5" : {
		"locked": true,
		"stars_collected": 0,
		"goals": {"coins_collected": 150}
	},
	"day_6" : {
		"locked": true,
		"stars_collected": 0,
		"goals": {"coins_collected": 175}
	},
	"day_7" : {
		"locked": true,
		"stars_collected": 0,
		"goals": {"coins_collected": 200}
	},
	"day_8" : {
		"locked": true,
		"stars_collected": 0,
		"goals": {"coins_collected": 225}
	},
	"day_9" : {
		"locked": true,
		"stars_collected": 0,
		"goals": {"coins_collected": 250}
	},
	"day_10" : {
		"locked": true,
		"stars_collected": 0,
		"goals": {"coins_collected": 275}
	},
	"day_11" : {
		"locked": true,
		"stars_collected": 0,
		"goals": {"coins_collected": 300}
	},
	"day_12" : {
		"locked": true,
		"stars_collected": 0,
		"goals": {"coins_collected": 325}
	},
}

# Kitchen upgrade information
var kitchen_upgrades: Dictionary = {
	"sale_counter": {
		"level": 0,
		"max_level": 20,
		"effect": "all_recipes",
		"multiplier": 1.0, # Starts at 1x
		"increment": 0.1, # Multiplier increases by 0.1 per upgrade
		"upgrade_cost": 100 # Starting cost for the first upgrade
	},
	"oven": {
		"level": 0,
		"max_level": 20,
		"effect": "certain_recipes",
		"recipes": "general_recipes",
		"flat_increase": 5, # Flat increase per level
		"increment": 1,
		"upgrade_cost": 75 # Starting cost for the first upgrade
	},
	"counters": {
		"level": 0,
		"max_level": 20,
		"effect": "certain_recipes",
		"recipes": "kneaded_recipes",
		"flat_increase": 5, # Flat increase per level
		"increment": 1,
		"upgrade_cost": 75
	},
	"fridge": {
		"level": 0,
		"max_level": 20,
		"effect": "certain_recipes",
		"recipes": "chilled_recipes",
		"flat_increase": 5, # Flat increase per level
		"increment": 1,
		"upgrade_cost": 75
	},
	"trash": {
		"level": 0,
		"max_level": 20,
		"effect": "failed_recipes",
		"base_penalty": 5,
		"reduction": 1, # Penalty reduction per level
		"upgrade_cost": 50,
	},
}

# Goal setup.
func setup_level_goal():
	star_thresholds.clear()  # Clear previous thresholds
	for i in range(1, 4):  # 1 to 3 stars
		star_thresholds.append((i * selected_goal[1]) / 3)
	print("Star Thresholds for", selected_goal[0], ": ", star_thresholds)
	
# Updates coins and customers served for the current level.
func update_level_coins_and_customers_served(coins_earned, customers_served) -> void:
	current_level_coins += coins_earned
	current_level_customers_served += customers_served

# Updates stars based on progress.
func update_current_level_stars():
	var progress = current_level_coins if selected_goal[0] == "coins_collected" else current_level_customers_served
	for i in range(3):  # 3 star thresholds
		if progress >= star_thresholds[i]:
			current_level_stars = max(current_level_stars, i + 1)
		else:
			break
	# print("Current Stars: ", current_level_stars)
	
# Resets current level stats.
func reset_current_level_stats() -> void:
	current_level_coins = 0
	current_level_customers_served = 0
	current_level_stars = 0
	
# Generates a goal.
func generate_goal() -> void:
	if "day_" + str(current_level) in level_info:
		var current_level_info = level_info["day_" + str(current_level)]
		var goal = current_level_info["goals"]
		var goal_name = goal.keys()[0]
		selected_goal = [goal_name, goal[goal_name]]
		print("Selected Goal: ", selected_goal)
	else:
		print("No goals defined for level", current_level)

# Completes the current level.
func complete_level():
	print("Completing Level: ", current_level)
	
	# Update stars for the current level.
	var earned_stars = current_level_stars
	var current_level_info = level_info["day_" + str(current_level)]
	var previous_stars = current_level_info.get("stars_collected", 0)

	if earned_stars > previous_stars:
		current_level_info["stars_collected"] = earned_stars
		print("Updated stars for level ", current_level, " to ", earned_stars)

	# Update total stats.
	total_coins += current_level_coins
	total_customers_served += current_level_customers_served
	total_stars = get_total_stars()

	# Reset current level stats.
	reset_current_level_stats()
	
	# Unlock next level only if on the furthest level.
	if current_level == furthest_level:
		unlock_next_level()

# Moves the player to the next level.
func unlock_next_level() -> void:
	if "day_" + str(furthest_level + 1) in level_info:
		furthest_level += 1
		level_info["day_" + str(furthest_level)]["locked"] = false
		print("Next Level: ", furthest_level)
		
# Calculates total stars across all levels.
func get_total_stars() -> int:
	var total = 0
	for child in level_info.values():
		total += child["stars_collected"]
	return total
	
# Returns the base trash penalty for the player. 
func get_base_penalty() -> int:
	return kitchen_upgrades["trash"]["base_penalty"]
	
# Returns the current reduction level.
func get_reduction_level() -> int:
	return kitchen_upgrades["trash"]["level"]

# Returns the reduction amount (constant)
func get_reduction_amount() -> int:
	return kitchen_upgrades["trash"]["reduction"]

# Returns the upgrade level for the player.
func get_upgrade_level(item: String) -> int:
	return kitchen_upgrades[item]["level"]
	
# Returns the upgrade cost for the player.
func get_upgrade_cost(item: String) -> int:
	return kitchen_upgrades[item]["upgrade_cost"]
	
# Checks if the kitchen item can be upgraded. 
func can_upgrade_kitchen_item(item: String) -> bool:
	var item_data = kitchen_upgrades[item]
	# If player reaches max level, they cannot upgrade the item any further.
	if total_coins >= item_data["upgrade_cost"] and item_data["level"] < item_data["max_level"]:
		return true
	else:
		return false

# Upgrades the kitchen item.
func upgrade_kitchen_item(item: String) -> bool:
	var item_data = kitchen_upgrades[item]
	# Check if player can afford the upgrade. 
	## NOTE: Not needed anymore since we disable the button if the player cannot afford it.
	if can_upgrade_kitchen_item(item):
		total_coins -= item_data["upgrade_cost"]
		item_data["level"] += 1
		
		# Apply the upgrade effect.
		if item_data.has("multiplier"):
			item_data["multiplier"] += item_data["increment"]
		elif item_data.has("flat_increase"):
			item_data["flat_increase"] += item_data["increment"]

		# Recalculate upgrade cost.
		item_data["upgrade_cost"] = _calculate_upgrade_cost(item_data["upgrade_cost"], item_data["level"])
		return true
	else:
		return false # Not enough money

# Calculates the total earnings for the specified recipe after adding flat increases and multipliers.
func calculate_recipe_earnings(base_price: int, recipe: String, recipe_category: String) -> int:
	var total_earnings = base_price
	
	# Apply increases (either multiplier or flat increases).
	for item_name in kitchen_upgrades.keys(): # Sale counter is listed first in dictionary, and therefore always goes first.
		var item_data = kitchen_upgrades[item_name]
		
		# Handle Sale Counter effects first.
		if item_data["effect"] == "all_recipes":
			total_earnings *= item_data.get("multiplier", 1.0)
		
		# Handle Counter, Fridge and Oven effects afterwards.
		if item_data["effect"] == "certain_recipes" and recipe_category == "kneaded_recipes":
			total_earnings += item_data.get("flat_increase", 0)
		# Fridge effects.
		elif item_data["effect"] == "certain_recipes" and recipe_category == "chilled_recipes":
			total_earnings += item_data.get("flat_increase", 0)
		# Oven effects.
		elif item_data["effect"] == "certain_recipes" and recipe_category == "general_recipes":
			total_earnings += item_data.get("flat_increase", 0)

	return int(total_earnings)
	
# Deletes file containing game stats. Only used when a player wants to start over again.
func delete_game_stats(path: String = "user://game_stats.json") -> void:
	DirAccess.remove_absolute(path)

# Saves game stats to file.
func save_game_stats(path: String = "user://game_stats.json") -> void:
	var file = FileAccess.open(path, FileAccess.ModeFlags.WRITE)
	if file:
		# Serialize the resource.
		var data = _to_dict()  # Serialize the resource
		file.store_string(JSON.stringify(data))  # Save as JSON
		file.close()
		print("Game stats saved to ", path)
	else:
		print("Failed to save game stats to", path)

# Loads game stats from file.
func load_game_stats(path: String = "user://game_stats.json") -> void:
	var file = FileAccess.open(path, FileAccess.ModeFlags.READ)
	if file:
		# Read the file as text.
		var content = file.get_as_text()
		# Parse the JSON.
		var json = JSON.new()
		var error = json.parse(content)
		## var data = JSON.parse_string(content)
		if error == OK:
			# Populate the resource.
			_from_dict(json.data)
			print("Game stats loaded from ", path)
		else:
			print("Failed to parse game stats:", error)
			file.close()
	else:
		print("Failed to load game stats from ", path)

# Calculates the upgrade cost of a kitchen item.
func _calculate_upgrade_cost(base_cost: int, level: int) -> int:
	return int(base_cost * pow(UPGRADE_COST_MULTIPLIER, level))
	
# Converts the resource data to a savable dictionary.
func _to_dict() -> Dictionary:
	return {
		"current_level": current_level,
		"total_coins": total_coins,
		"total_customers_served": total_customers_served,
 		"total_stars": total_stars,
		"level_info": level_info,
		"kitchen_upgrades": kitchen_upgrades
	}

# Loads data from a dictionary into the resource.
func _from_dict(data: Dictionary) -> void:
	current_level = data.get("current_level", 1)
	total_coins = data.get("total_coins", 0)
	total_customers_served = data.get("total_customers_served", 0)
	total_stars = data.get("total_stars", 0)
	level_info = data.get("level_info", {})
	kitchen_upgrades = data.get("kitchen_upgrades", {})
