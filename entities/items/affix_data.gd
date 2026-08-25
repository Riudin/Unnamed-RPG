class_name AffixData
extends Resource


@export var is_prefix: bool = true
@export var name_format: String

@export var min_tier: int = 1
@export var max_tier: int = 2
var tier: int = 1

@export var tier_values: Dictionary = {
	1: {
		"min": 1,
		"max": 3,
		"min_range": 4,
		"max_range": 6
		},
	2: {
		"min": 3,
		"max": 5,
		"min_range": 8,
		"max_range": 10
		}
}

@export var mods: Array[StatModifier] = [] # this should atm only be one mod. some things like tier values are not prepared for multiple mods


func assign_values_to_mods() -> void:
	for mod in mods:
		if mod == null: continue

		mod.min_amount = tier_values[tier]["min"]
		mod.range_min_amount = tier_values[tier]["min_range"]
		mod.max_amount = tier_values[tier]["max"]
		mod.range_max_amount = tier_values[tier]["max_range"]


func roll_value(mod: StatModifier, rng: RandomNumberGenerator = null) -> void:
	mod.roll_amount(rng)
