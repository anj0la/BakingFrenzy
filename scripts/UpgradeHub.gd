extends Control

@export var game_stats: Resource

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	## NOTE: Enable / disable buttons based on the amount of money a player has
	$MenuStatsContainer/Coins.text = str(game_stats.total_coins)
	for child in get_children():
		if child.get_class() == "VBoxContainer":
			_initialize_upgrade_scene(child)

# Initializes the upgrade scene by displaying upgrade levels and upgrade button status (disabled or enabled).
func _initialize_upgrade_scene(item: VBoxContainer) -> void:
	# Get required variables needed to display and potentially upgrade items.
	var item_name = item.name.to_lower() if item.name != "SaleCounter" else "sale_counter"
	print(item_name)
	var level_label = item.get_child(0)
	var upgrade_button = item.get_child(1)
	var upgrade_container = upgrade_button.get_child(0)
	var req_coins = upgrade_container.get_child(0)
	
	# Set level and buttons labels, and either enable or disable upgrade button.
	level_label.text = "LVL " + str(game_stats.get_upgrade_level(item_name))
	upgrade_button.disabled = not game_stats.can_upgrade_kitchen_item(item_name)
	req_coins.text = str(game_stats.get_upgrade_cost(item_name))

	# Changes button colour to indicate to players that they can / cannot afford the upgrade.
	if not upgrade_button.disabled:
		var upgrade_arrow = upgrade_button.get_child(1)
		upgrade_button.modulate = Color.WHITE
		upgrade_arrow.visible = true
	else:
		var upgrade_arrow = upgrade_button.get_child(1)
		upgrade_button.modulate = Color.GRAY
		upgrade_arrow.visible = false

	# Connect the button signal to upgrade kitchen items.
	if upgrade_button.pressed.is_connected(_on_upgrade_button_pressed):
		upgrade_button.pressed.disconnect(_on_upgrade_button_pressed)  # Avoid duplicate connections.
	upgrade_button.pressed.connect(_on_upgrade_button_pressed.bind(item_name, level_label, upgrade_button))
	
# Upgrades the specific kitchen item and enables or disbales the upgrade button.
func _on_upgrade_button_pressed(item_name: String, level_label: Label, upgrade_button: Button) -> void:
	# Get required variables to upgrade item.
	var upgrade_container = upgrade_button.get_child(0)
	var req_coins = upgrade_container.get_child(0)
	
	# Upgrade the level of the kitchen item.
	game_stats.upgrade_kitchen_item(item_name)
	
	# Set level and buttons labels, and either enable or disable upgrade button.
	level_label.text = "Level " + game_stats.get_upgrade_level(item_name)
	upgrade_button.disabled = not game_stats.can_upgrade_kitchen_item(item_name)
	upgrade_button.text = str(game_stats.get_upgrade_cost(item_name))
	
	# Changes button colour to indicate to players that they can / cannot afford the upgrade.
	if not upgrade_button.disabled:
		var upgrade_arrow = upgrade_button.get_child(1)
		upgrade_button.modulate = Color.WHITE
		upgrade_arrow.visible = true
	else:
		var upgrade_arrow = upgrade_button.get_child(1)
		upgrade_button.modulate = Color.GRAY
		upgrade_arrow.visible = false
		
	# Save game after every upgrade.
	game_stats.save_game_stats()
	
	# Update total coins label.
	$MenuStatsContainer/Coins.text = str(game_stats.total_coins)

# Quits the game.
func _on_close_button_pressed() -> void:
	game_stats.save_game_stats()
	get_tree().quit()

# Returns the player back to the Bakery Hub.
func _on_home_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/BakeryHub.tscn")
