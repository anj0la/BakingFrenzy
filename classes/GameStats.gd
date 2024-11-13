extends Resource

# Class definition.
class_name GameStats

# Total game stats
@export var total_currency: int
@export var total_customers_served: int

func _init() -> void:
	# Load total stats.
	total_currency = 0 # TODO: Placeholder.
	total_customers_served = 0 # TODO: Placeholder.

func commit_level_stats_to_total(level_currency: int, level_customers_served: int) -> void:
	total_currency += level_currency
	total_customers_served += level_customers_served
