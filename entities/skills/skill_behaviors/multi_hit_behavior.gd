class_name MultiHitBehavior
extends SkillBehavior


@export var hit_count: int = 2


func execute(context: BattleContext, skill: SkillData):
	for i in hit_count:
		var instance = context.build_damage_instance(
			skill.base_damage_sources,
			skill.stat_modifiers
		)
		#print("--damage instance built: ", instance)

		context.deal_damage(instance)
