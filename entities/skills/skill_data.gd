class_name SkillData
extends Resource


# Skill Tags
enum SkillTag {
	ATTACK,
	SPELL,
	MELEE,
	PROJECTILE,
	AOE,
	DURATION
	}

# Skill Base Stats
@export var skill_name: String

@export var tags: Array[SkillTag]
@export var skill_damage_data: Array[DamageData]
@export var behaviors: Array[SkillBehavior]

# @export var base_dmg_min: float
# @export var base_dmg_max: float
@export var base_speed: float
@export var mana_cost: float