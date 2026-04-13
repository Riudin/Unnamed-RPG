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

@export var windup_animation_name: String = "idle"
@export var projectile: PackedScene = null
@export var projectile_speed: float = 400.0

@export var tags: Array[SkillTag]
@export var base_damage_sources: Array[DamageSource]
@export var stat_modifiers: StatBlock
@export var behaviors: Array[SkillBehavior]

@export var base_speed: float
@export var mana_cost: float


func execute(context: BattleContext) -> void:
	# Execute each behavior sequentially, waiting for completion
	for behavior in behaviors:
		await behavior.execute(context, self )
		if projectile != null:
			spawn_projectile(context)


func spawn_projectile(context: BattleContext):
	var proj = projectile.instantiate()
	proj.position.y -= 16.0
	proj.target = Vector2(context.defender.global_position.x, context.defender.global_position.y - 16.0)
	proj.speed = projectile_speed
	proj.animation = skill_name
	context.attacker.add_child(proj)