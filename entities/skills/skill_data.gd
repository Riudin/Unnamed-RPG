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

@export_group("Basic Info")
@export var skill_name: String
@export var tags: Array[SkillTag]

@export_group("Visuals")
@export var skill_icon: Texture2D
@export var windup_animation_name: String = "idle"
@export var projectile_speed: float = 400.0
@export var emit_particles: bool = false

@export_group("Damage Data")
@export var base_damage_sources: Array[DamageSource]
@export var stat_modifiers: StatBlock

@export_group("Behavior")
@export var behaviors: Array[SkillBehavior]
@export var base_speed: float
@export var mana_cost: float

var projectile: PackedScene = preload("uid://ce0b6wmvlgec2")


func execute(context: BattleContext) -> void:
	# Execute each behavior sequentially, waiting for completion
	for behavior in behaviors:
		await behavior.execute(context, self )
		if tags.has(SkillTag.PROJECTILE):
			spawn_projectile(context)


func spawn_projectile(context: BattleContext):
	var proj = projectile.instantiate()
	proj.position.y -= 16.0
	proj.target = Vector2(context.defender.global_position.x, context.defender.global_position.y - 16.0)
	proj.speed = projectile_speed
	proj.animation = skill_name
	proj.has_particles = emit_particles
	context.attacker.add_child(proj)