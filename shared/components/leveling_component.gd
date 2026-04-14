class_name LevelingComponent
extends Node


@onready var parent: Node = get_parent()
 
var attribute_data: AttributeData
@export var level_table: LevelTable

# Attribute gains per level
@export var strength_gain_per_level: float = 1.0
@export var dexterity_gain_per_level: float = 1.0
@export var intelligence_gain_per_level: float = 1.0
@export var vitality_gain_per_level: float = 1.0

# Secondary property gains per level
@export var flat_max_life_per_level: float = 12.0
@export var flat_max_mana_per_level: float = 2.0
@export var skill_points_per_level: int = 1
 

@export var level: int = 1:
	set(value):
		# level = value
		GameState.player_data.level = value

@export var current_xp: int = 0:
	set(value):
		# current_xp = value
		GameState.player_data.current_xp = value

@export var skill_points: int = 0:
	set(value):
		# skill_points = value
		GameState.player_data.skill_points = value

 
func _ready():
	assert(parent != null, "assign to a Parent")
	attribute_data = parent.attribute_data

	assert(attribute_data != null, "assign an AttributeData resource")
	assert(level_table != null, "assign a LevelTable resource")

	#SignalBus.xp_changed.emit(current_xp, level_table.xp_to_next(level))

	#SaveManager.game_loaded.connect(_on_game_loaded)
	level = GameState.player_data.level
	current_xp = GameState.player_data.current_xp
	skill_points = GameState.player_data.skill_points
	refresh_ui()
 

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

		# Apply attribute gains for this level
		attribute_data.strength += strength_gain_per_level
		attribute_data.dexterity += dexterity_gain_per_level
		attribute_data.intelligence += intelligence_gain_per_level
		attribute_data.vitality += vitality_gain_per_level
		
		attribute_data.max_health += flat_max_life_per_level
		attribute_data.max_mana += flat_max_mana_per_level
		
		skill_points += skill_points_per_level
		
		SignalBus.leveled_up.emit(level, 1, skill_points_per_level)
 
	if levels_gained > 1:
		SignalBus.leveled_up.emit(level, levels_gained, skill_points)
	SignalBus.xp_changed.emit(current_xp, level_table.xp_to_next(level))


func refresh_ui():
	# Send the level signals with just the current values so the ui refreshes
	SignalBus.leveled_up.emit(level, 0, 0)
	SignalBus.xp_changed.emit(current_xp, level_table.xp_to_next(level))


# func _on_game_loaded():
# 	refresh_ui()
