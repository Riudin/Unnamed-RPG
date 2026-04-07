class_name SingleHitBehavior
extends SkillBehavior


func execute(context: BattleContext, skill: SkillData):
	var instance = context.build_damage_instance(
		skill.base_damage_sources,
		skill.stat_modifiers
	)
	#print("--damage instance built: ", instance)

	context.deal_damage(instance)