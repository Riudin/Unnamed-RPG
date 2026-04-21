class_name EnemyData
extends Resource


@export var name: String = "Name Missing"
@export var texture: Texture2D

@export var stats: Stats = null
@export var equipped_skills: Array[SkillData]
@export var active_skill: SkillData = null:
	set(new_value):
		if active_skill and not active_skill.inherent_mods.is_empty():
			for mod in active_skill.inherent_mods:
				stats.remove_modifier(mod)
		active_skill = new_value
		if active_skill and not active_skill.inherent_mods.is_empty():
			for mod in active_skill.inherent_mods:
				stats.add_modifier(mod)

@export var drop_table: ItemDropTable
