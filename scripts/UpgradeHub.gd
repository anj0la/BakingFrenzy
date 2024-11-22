extends Control

@export var game_stats: Resource

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	## NOTE: Enable / disable buttons based on the amount of money a player has
	for child in get_children():
		if child.get_class() == "VBoxContainer":
			_initialize_upgrade_scene(child)

# Initializes the upgrade scene by displaying upgrade levels and upgrade button status (disabled or enabled).
func _initialize_upgrade_scene(item: VBoxContainer) -> void:
	var item_name = item.name.to_lower() if not "salecounter" else "sale_counter"
	var level_label = item.get_child(0)
	var upgrade_button = item.get_child(1)
	
	level_label.text = "Level " + str(game_stats.get_upgrade_level(item_name))
	upgrade_button.disabled = not game_stats.can_upgrade_kitchen_item(item_name)
	
	# Connect the button signal to upgrade kitchen items.
	if upgrade_button.pressed.is_connected(_on_upgrade_button_pressed):
		upgrade_button.pressed.disconnect(_on_upgrade_button_pressed)  # Avoid duplicate connections.
	upgrade_button.pressed.connect(_on_upgrade_button_pressed.bind(item_name, level_label, upgrade_button))
	
# Upgrades the specific kitchen item and enables or disbales the upgrade button.
func _on_upgrade_button_pressed(item_name: String, level_label: Label, upgrade_button: Button) -> void:
	game_stats.upgrade_kitchen_item(item_name)
	level_label.text = "Level " + game_stats.get_upgrade_level(item_name)
	upgrade_button.disabled = not game_stats.can_upgrade_kitchen_item(item_name)

	

	
