class_name SingleHitBehavior
extends SkillBehavior


func execute(context: BattleContext, _skill: SkillData, on_hit: Callable) -> void:
	var instance = context.build_damage_instance()
	#print("--damage instance built: ", instance)

	var is_crit: bool = context.determine_crit(instance)
	var damage_dealt: float = context.deal_damage(instance, is_crit)
	on_hit.call(damage_dealt, is_crit)
