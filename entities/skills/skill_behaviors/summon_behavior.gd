class_name SummonBehavior
extends SkillBehavior


@export var summon_count: int = 1


func execute(_context: BattleContext, skill: SkillData) -> void:
	for summon in range(summon_count):
		# var data := EnemyData.new()
		# data.name = "Skeleton"
		# data.texture = skill.summon_texture
		# skill.summon_data.stats = skill.summon_stats.snapshot()
		# skill.summon_data.stats.recalculate_stats()
		# data.level = 1
		# data.equipped_skills = skill.summon_skills
		SignalBus.summon_requested.emit(skill.summon_data)
