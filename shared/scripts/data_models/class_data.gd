class_name ClassData
extends Resource


enum PlayerClass {
	STRENGTH,
	DEXTERITY,
	INTELLIGENCE
}

@export var class_id: PlayerClass = PlayerClass.STRENGTH
@export var display_name: String = "Strength Class"

# Increase primary attribures per level
@export var primary_gain_per_level: float = 3.0
@export var strength_gain_per_level: float = 1.0
@export var intelligence_gain_per_level: float = 1.0
@export var dexterity_gain_per_level: float = 1.0
@export var vitality_gain_per_level: float = 1.0

# Increase secondary properties per level
@export var flat_max_life_per_level: float = 12.0
@export var flat_max_mana_per_level: float = 2.0
@export var armor_per_strength: float = 0.5

# Gain Skill Points per level
@export var skill_points_per_level: int = 1


func _init() -> void:
	if class_id == PlayerClass.STRENGTH:
		strength_gain_per_level = primary_gain_per_level
	elif class_id == PlayerClass.DEXTERITY:
		dexterity_gain_per_level = primary_gain_per_level
	elif class_id == PlayerClass.INTELLIGENCE:
		intelligence_gain_per_level = primary_gain_per_level
	

func apply_level_up(attribute_data: AttributeData, levels: int = 1) -> Dictionary:
	if not attribute_data or not attribute_data is AttributeData:
		return {"success": false, "error": "Invalid attribute_data"}

	attribute_data.strength += strength_gain_per_level * levels
	attribute_data.dexterity += dexterity_gain_per_level * levels
	attribute_data.intelligence += intelligence_gain_per_level * levels
	attribute_data.vitality += vitality_gain_per_level * levels

	attribute_data.max_health += flat_max_life_per_level * levels
	attribute_data.max_mana += flat_max_mana_per_level * levels

	attribute_data.armor += (strength_gain_per_level * levels) * armor_per_strength

	return {
		"success": true,
		"skill_points_awarded": skill_points_per_level * levels,
		"levels_applied": levels
	}
