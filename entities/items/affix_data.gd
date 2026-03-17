class_name AffixData
extends Resource


@export var is_prefix: bool = true
@export var name_format: String
@export var stat_name: String # This must match the stat in AttributeData that will be affected

@export var min_value: float = 1.0
@export var max_value: float = 10.0

func roll_value() -> float:
	return roundf(randf_range(min_value, max_value))