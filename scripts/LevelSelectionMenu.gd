extends Control

@export var game_stats: Resource

## NOTE: Need to get information on levels.
const LEVELS_PER_PAGE: int = 12
const MAX_LEVEL: int = 60 
var current_page: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Avoid displaying prev button if only first page is accessible.
	if game_stats.furthest_level <= LEVELS_PER_PAGE:
		$PrevButton.visible = false
	# Avoid displaying next button if the player has reached the last page.
	if game_stats.furthest_level > MAX_LEVEL - LEVELS_PER_PAGE:
		$NextButton.visible = false
		
	current_page = int((game_stats.furthest_level - 1) / LEVELS_PER_PAGE)
	_update_level_buttons()
			
# Updates all level buttons.
func _update_level_buttons() -> void:
	var start_index = current_page * LEVELS_PER_PAGE + 1
	for i in range(LEVELS_PER_PAGE):
		var level_index = start_index + i
		var level_data = game_stats.level_info["day_" + str(level_index)]
		var button = $LevelGridContainer.get_child(i)
		button.text = str(level_index)  # Display level number on the button
		button.disabled = level_data["locked"]
		
		# Connect the button signal to handle level selection.
		if button.pressed.is_connected(_on_button_pressed):
			button.pressed.disconnect(_on_button_pressed)  # Avoid duplicate connections.
		button.pressed.connect(_on_button_pressed.bind(level_index))
		
# Returns the player to the Bakery Hub.
func _on_home_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/BakeryHub.tscn")
	
# Selects the chosen level.
func _on_button_pressed(level_index: int) -> void:
	# Set the selected level as current_level.
	game_stats.current_level = level_index
	print("Selected Level: ", level_index)
	
	# Transition to the game screen.
	get_tree().change_scene_to_file("res://scenes/Game.tscn")
	
