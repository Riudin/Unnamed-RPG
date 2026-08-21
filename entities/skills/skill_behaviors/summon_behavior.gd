class_name SummonBehavior
extends SkillBehavior


@export var summon_count: int = 1


func execute(context: BattleContext, skill: SkillData) -> void:
	for summon in summon_count:
		var data := EnemyData.new()
		data.name = "Skeleton"
		data.texture = skill.summon_texture
		data.stats = skill.summon_stats.snapshot()
		data.stats.recalculate_stats()
		data.level = 1
		data.equipped_skills = skill.summon_skills

		SignalBus.summon_requested.emit(data)
