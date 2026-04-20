class_name AffixData
extends Resource


@export var is_prefix: bool = true
@export var name_format: String

@export var mods: Array[StatModifier] = []


func roll_value(mod: StatModifier) -> float:
	mod.amount = randf_range(mod.min_amount, mod.max_amount)
	return mod.amount
