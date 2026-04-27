class_name HitBehavior
extends SkillBehavior


@export var hit_count: int = 1
@export var delay_between_hits: float = 0.3 # seconds between each hit


func execute(context: BattleContext, skill: SkillData) -> void:
	for i in hit_count:
		# Delay before this hit (except on first hit)
		if not context.attacker:
			return

		if i > 0:
			await context.attacker.get_tree().create_timer(delay_between_hits).timeout
		
		if skill.tags.has(SkillData.SkillTag.PROJECTILE):
			# Calculate damage when creating the projectile
			#var instance = context.build_damage_instance()
			#var is_crit: bool = context.determine_crit(instance)
			#var damage_dealt: float = context.deal_damage(instance, is_crit)
			# var projectile_context = BattleContext.new()
			# projectile_context.attacker = context.attacker
			# projectile_context.defender = context.defender
			# projectile_context.attacker_stats = context.attacker_stats
			var instance = context.build_damage_instance()
			var is_crit: bool = DamageSystem.resolve_crit(instance)
			var damage_dealt: int = DamageSystem.resolve(instance, is_crit)

			_spawn_projectile(context, skill, damage_dealt, is_crit)
			#projectile.connect("target_hit", Callable(self , "_deal_damage").bindv([context])) # damage_dealt, is_crit, context.defender.global_position]))
		else:
		# Deal damage for this hit
			_deal_damage(context)


func _spawn_projectile(context: BattleContext, skill: SkillData, damage: int, is_crit: bool) -> Node:
	if context.defender == null or context.attacker == null:
		return null

	var proj = skill.projectile.instantiate()
	proj.position.y -= 16.0
	#proj.target = context.defender
	proj.target_pos = Vector2(context.defender.global_position.x, context.defender.global_position.y - 16.0)
	proj.speed = skill.projectile_speed
	proj.animation = skill.skill_name
	proj.has_particles = skill.emit_particles
	proj.damage_dealt = damage
	proj.is_crit = is_crit
	proj.context = context
	context.attacker.add_child(proj)
	#if proj: proj.connect("target_hit", Callable(self , "_deal_damage").bindv([context])) # damage_dealt, is_crit, context.defender.global_position]))
	return proj


func _deal_damage(context: BattleContext):
	if context.defender == null:
		print("ERROR: context.defender is null!")
		return
		
	var instance = context.build_damage_instance()
	var is_crit: bool = DamageSystem.resolve_crit(instance)
	var damage_dealt: int = DamageSystem.resolve(instance, is_crit)

	if instance.defender and instance.defender.health_component.has_method("take_damage"):
		instance.defender.health_component.take_damage(damage_dealt)

	if context.defender:
		DamagePopupManager.spawn(
			int(damage_dealt),
			context.defender.global_position,
			#DamagePopupManager.damage_colors[damage_source.damage_type],
			Color.WHITE,
			is_crit
			)


# func _deal_damage_with_value(damage_dealt: float, is_crit: bool, target_pos: Vector2) -> void:
# 	# Use pre-calculated damage value (for projectiles)
	
# 	DamagePopupManager.spawn(
# 		int(damage_dealt),
# 		target_pos,
# 		Color.WHITE,
# 		is_crit
# 	)
