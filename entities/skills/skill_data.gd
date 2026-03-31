class_name SkillData
extends Resource

### Basic Information about a skill. Further information like flat damage, scaling and behaviour are fround in corresponding classes


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
@export var skill_icon: Texture2D

@export var tags: Array[SkillTag]
@export var base_damage_sources: Array[DamageSource]
@export var stat_modifiers: StatBlock
@export var behaviors: Array[SkillBehavior]

@export var base_speed: float
@export var mana_cost: float


func execute(context: BattleContext):
	# TODO: maybe wait for previous behavior to finish
	for behavior in behaviors:
		behavior.execute(context, self )