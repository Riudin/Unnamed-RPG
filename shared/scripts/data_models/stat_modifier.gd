class_name StatModifier
extends Resource


enum ModifierType {
	ADD,
	MULTIPLY,
	MORE # for the future. no more multipliers in the game yet
}

@export var stat: Stats.ModifiableStats
@export var type: ModifierType
@export var min_amount: float
@export var max_amount: float
@export var description: String

var amount: float = 0.0: get = _get_amount


func _get_amount() -> float:
	if type == null:
		return amount
	else:
		match type:
			ModifierType.ADD:
				return roundf(amount)
			ModifierType.MULTIPLY:
				return snapped(amount / 100.0, 0.01)
			ModifierType.MORE:
				return 1.0 + snapped(amount / 100.0, 0.01)
			_:
				return amount


func get_display_text() -> String:
	var display_amount: float
	match type:
			ModifierType.ADD:
				display_amount = amount
			ModifierType.MULTIPLY:
				display_amount = amount * 100.0
			ModifierType.MORE:
				display_amount = (amount - 1.0) * 100.0

	return description % display_amount