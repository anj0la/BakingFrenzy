extends CanvasLayer

const BASE_RATE: int = 5
@export var seconds_per_in_game_hour: int # 6, 12, 18
var current_in_game_hour: float # 8.0, 8.1
var increment_interval: float # Define the interval at which to increment in-game time by 0.1 hours

# Called when the node enters the scene tree for the first time.
func _ready() -> void: 
	increment_interval = seconds_per_in_game_hour / BASE_RATE
	current_in_game_hour = 13.0 # Start at 8:00 AM.
	display_time_in_hud(current_in_game_hour)
	
# Time goes from 8:00 AM to 6:00 PM -> 10 intervals
# 6 seconds = 1 hour (10 minutes per second): 10 hours in-game takes 60 seconds in real time.
# 9 seconds = 1 hour (10 minutes per 1.5 seconds): 10 hours takes 90 seconds.
# 12 seconds = 1 hour (10 minutes per 2 seconds): 10 hours takes 120 seconds.
# Updates the in-game time based on the remaining seconds.
func update_time_indicator(remaining_seconds: int) -> void:
	# Currently, hour changes every 24 seconds. 8.0 -> 8.5 -> 9.0.
	if remaining_seconds % int(increment_interval) == 0:
		if current_in_game_hour - floor(current_in_game_hour) < 0.5:
			current_in_game_hour += 0.1
		else:
			# Move to next full hour if we're at 0.5
			current_in_game_hour = floor(current_in_game_hour) + 1.0
			
	# Display in HUD
	display_time_in_hud(current_in_game_hour)
	
func display_time_in_hud(in_game_hour: float) -> void:
	var hours = int(in_game_hour)
	var minutes = round((in_game_hour - floor(in_game_hour)) * 100)
	var am_pm_indicator = " AM" if hours < 12 else " PM"
	
	# Convert hours to 12-hour format for display
	var display_hour = hours if hours <= 12 else hours - 12
	if display_hour == 0:
		display_hour = 12  # Handle 12 AM/PM edge case
	
	# Format minutes with padding
	var display_minutes = str(minutes).pad_zeros(2)
	print(str(display_hour) + ":" + display_minutes + am_pm_indicator)
	
	# print(str(hours) + ":" + "00" if minutes < 1 else str(minutes) + am_pm_indicator)


		
		
	# assume seconds = 6
	# 60 % 6 = 10
	# 60 / 6, 120 / 12, 90 / 9 -> use modulo?
	# 60 % 6 == 0
	# 54 % 6
	
	# for 60 seconds, every second we increment by .1
	# for 120 seconds, every 2 seconds we increment by .1
	# for 180 seconds, every 3 seconds we increment by .1
	
	# Format time
	# 120 % 12 == 0 -> 1 hour (10)
	# 119 % 12 == 11 -> do nothing.
	# 118 % 12 == 10 -> increment by .1 -> 8.1
	# 116 % 12 == 8 --> increment by .1. -> 9.2
	# 114 -> 8.3
	# 112 -> 8.4
	# 110 -> 8.5
	# 108 % 12 == 0 -> 2 hours (9) -> 9.0
	
	
	
	# 96 % 12 == 0 -> 3 hours (8)
	# 84 % 12 == 0 -> 4 hours (7)
	# 72 % 12 == 0 -> 5 hours (6)
	# 60 % 12 == 0 -> 6 hours (5)
	# 48 % 12 == 0 -> 7 hours (4)
	# 36 % 12 == 0 -> 8 hours (3)
	# 24 % 12 == 0 -> 9 hours (2)
	# 12 % 12 == 0 -> 10 hours (1) -> or we stop here, so when 12 == 12
