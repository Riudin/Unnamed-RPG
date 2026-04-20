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
		await behavior.execute(context, self , func(dmg, is_crit):
			_on_behavior_executed(context, dmg, is_crit)
			)


func _on_behavior_executed(context: BattleContext, damage_dealt: float, is_crit: bool):
	if tags.has(SkillTag.PROJECTILE):
			spawn_projectile(context, damage_dealt, is_crit)
	else:
		# TODO: here an animation or a hit of some form should be triggered that then has the responsibility to spawn the damage popup instead
		DamagePopupManager.spawn(
		int(damage_dealt),
		context.defender.global_position,
		#DamagePopupManager.damage_colors[damage_source.damage_type],
		Color.WHITE,
		is_crit
	)


func spawn_projectile(context: BattleContext, damage: float, is_crit: bool):
	if context.defender == null:
		return

	var proj = projectile.instantiate()
	proj.position.y -= 16.0
	proj.target = Vector2(context.defender.global_position.x, context.defender.global_position.y - 16.0)
	proj.speed = projectile_speed
	proj.animation = skill_name
	proj.has_particles = emit_particles
	proj.damage_dealt = damage
	proj.is_crit = is_crit
	context.attacker.add_child(proj)
