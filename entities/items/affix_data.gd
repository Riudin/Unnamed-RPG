class_name AffixData
extends Resource


@export var is_prefix: bool = true
@export var name_format: String
@export var stat_name: String # This must match the stat in AttributeData that will be affected

@export var min_value: int = 1
@export var max_value: int = 10

func roll_value() -> float:
	return randi_range(min_value, max_value)