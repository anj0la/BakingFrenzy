extends Resource

# Level-related stats
var current_level: int = 1
var current_level_coins: int = 0
var current_level_customers_served: int = 0
var current_level_stars: int = 0

# Global stats
var total_coins: int = 0
var total_customers_served: int = 0
var total_stars: int = 0

# Per-level stats
var level_stars: Dictionary = {"day_1": 0, "day_2": 0, "day_3": 0}
var level_goals: Dictionary = {
	"day_1": {"customers_served": 5, "coins_collected": 50},
	"day_2": {"customers_served": 7, "coins_collected": 75},
	"day_3": {"customers_served": 10, "coins_collected": 100},
}
var selected_goal: Array = []
var star_thresholds: Array = []

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
	
# Generates a random goal.
func generate_goal() -> void:
	if "day_" + str(current_level) in level_goals:
		var potential_goals = level_goals["day_" + str(current_level)]
		var rand_index = randi() % potential_goals.size()
		var goal_name = potential_goals.keys()[rand_index]
		selected_goal = [goal_name, potential_goals[goal_name]]
		print("Selected Goal: ", selected_goal)
	else:
		print("No goals defined for level", current_level)

# Completes the current level.
func complete_level():
	print("Completing Level:", current_level)
	
	# Update stars for the current level
	var earned_stars = current_level_stars
	var previous_stars = level_stars.get("day_" + str(current_level), 0)
	if earned_stars > previous_stars:
		level_stars["day_" + str(current_level)] = earned_stars
		print("Updated stars for level ", current_level, "to ", earned_stars)

	# Update total stats
	total_coins += current_level_coins
	total_customers_served += current_level_customers_served
	total_stars = get_total_stars()

	# Reset current level stats
	current_level_coins = 0
	current_level_customers_served = 0
	current_level_stars = 0

	# Unlock next level
	progress_to_next_level()

# Progress to the next level.
func progress_to_next_level() -> void:
	current_level += 1
	print("Progressed to Level: ", current_level)

# Calculate total stars across all levels.
func get_total_stars() -> int:
	var total = 0
	for stars in level_stars.values():
		total += stars
	return total

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
		print("Failed to load game stats from", path)

# Converts the resource data to a savable dictionary.
func _to_dict() -> Dictionary:
	return {
		"current_level": current_level,
		"total_coins": total_coins,
		"total_customers_served": total_customers_served,
 		"total_stars": total_stars,
		"level_stars": level_stars,
		"level_goals": level_goals,
	}

# Loads data from a dictionary into this resource.
func _from_dict(data: Dictionary) -> void:
	current_level = data.get("current_level", 1)
	total_coins = data.get("total_coins", 0)
	total_customers_served = data.get("total_customers_served", 0)
	total_stars = data.get("total_stars", 0)
	level_stars = data.get("level_stars", {})
	level_goals = data.get("level_goals", {})
