class_name StatModifier
extends Resource


enum ModifierType {
	ADD,
	ADD_RANGE,
	MULTIPLY,
	MORE # for the future. no more multipliers in the game yet
}

@export var stat: Stats.ModifiableStats
@export var type: ModifierType
@export var min_amount: float
@export var max_amount: float
@export var range_min_amount: float
@export var range_max_amount: float
@export var description: String

@export var amount: float = 0.0: get = _get_amount
@export var range_amount: float = 0.0: get = _get_range_amount


func roll_amount() -> void:
	amount = randf_range(min_amount, max_amount)

	if type == ModifierType.ADD_RANGE:
		range_amount = randf_range(range_min_amount, range_max_amount)


func _get_amount() -> float:
	match type:
		ModifierType.ADD:
			return roundf(amount)
		ModifierType.ADD_RANGE:
			return roundf(amount)
		ModifierType.MULTIPLY:
			return snapped(amount / 100.0, 0.01)
		ModifierType.MORE:
			return 1.0 + snapped(amount / 100.0, 0.01)
		_:
			return amount


func _get_range_amount() -> float:
	match type:
		ModifierType.ADD_RANGE:
			return roundf(range_amount)
		_:
			return 0.0


func get_display_text() -> String:
	match type:
			ModifierType.ADD:
				return description % amount
			ModifierType.ADD_RANGE:
				return description % [amount, range_amount]
			ModifierType.MULTIPLY:
				return description % (amount * 100.0)
			ModifierType.MORE:
				return description % ((amount - 1.0) * 100.0)
			_:
				return "ERROR: ModifierType unknown"