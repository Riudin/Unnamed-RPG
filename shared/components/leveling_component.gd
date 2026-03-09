class_name LevelingComponent
extends Node


@onready var parent: Node = get_parent()
 
var attribute_data: AttributeData
@export var class_data: ClassData
@export var level_table: LevelTable
 
@export var level: int = 1
@export var current_xp: int = 0
@export var skill_points: int = 0

 
func _ready():
	assert(parent != null, "assign to a Parent")
	attribute_data = parent.attribute_data

	assert(attribute_data != null, "assign an AttributeData resource")
	assert(class_data != null, "assign a ClassData resource")
	assert(level_table != null, "assign a LevelTable resource")

	SignalBus.xp_changed.emit(current_xp, level_table.xp_to_next(level))
 

func add_xp(amount: int) -> void:
	if amount <= 0:
		return
 
	current_xp += amount
	SignalBus.xp_changed.emit(current_xp, level_table.xp_to_next(level))
	_check_level_up()


func _check_level_up() -> void:
	var levels_gained := 0
	while current_xp >= level_table.xp_to_next(level) and level < level_table.max_level:
		var xp_required = level_table.xp_to_next(level)
		current_xp -= xp_required
		level += 1
		levels_gained += 1
 
		var res = class_data.apply_level_up(attribute_data, 1)
		if res.has("skill_points_awarded"):
			skill_points += int(res["skill_points_awarded"])
 
		SignalBus.leveled_up.emit(level, 1, res.get("skill_points_awarded", 0))
 
	if levels_gained > 1:
		SignalBus.leveled_up.emit(level, levels_gained, skill_points)
	SignalBus.xp_changed.emit(current_xp, level_table.xp_to_next(level))
