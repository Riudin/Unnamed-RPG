class_name MultiHitBehavior
extends SkillBehavior


@export var hit_count: int = 2
@export var delay_between_hits: float = 0.2  # seconds between each hit


func execute(context: BattleContext, skill: SkillData) -> void:
	for i in hit_count:
		# Deal damage for this hit
		var instance = context.build_damage_instance(
			skill.base_damage_sources,
			skill.stat_modifiers
		)
		context.deal_damage(instance)
		
		# Delay before next hit (except on last hit)
		if i < hit_count - 1:
			await context.attacker.get_tree().create_timer(delay_between_hits).timeout
