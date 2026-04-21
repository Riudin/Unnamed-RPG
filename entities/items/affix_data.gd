class_name AffixData
extends Resource


@export var is_prefix: bool = true
@export var name_format: String

@export var mods: Array[StatModifier] = []


func roll_value(mod: StatModifier) -> void:
	mod.roll_amount()
