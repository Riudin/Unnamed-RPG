class_name EnemyData
extends Resource


enum EnemyType {NORMAL, ELITE, BOSS}

@export_group("Base Data")
@export var type: EnemyType = EnemyType.NORMAL
@export var name: String = "Name Missing"
@export var texture: Texture2D
@export var icon: Texture2D

@export_group("Stats")
@export var stats: Stats = null
@export var level: int = 1
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

@export_group("Item Drops")
@export var base_drop_slots: int = 1 # each slot represents a chance to drop an item
@export var base_drop_chance: float = 0.2 # chance to drop an item per slot. if modified beyond 1, additional items can be dropped
@export var special_drop_slots: int = 0 # slots for drops specific to this enemy
@export var special_drop_chance: float = 0.0 # chance for special drop slots
@export var special_drop_table: ItemDropTable = null # used by special drop slots and additional to the default trop table

@export_group("Curves")
@export var damage_curve: Curve = preload("uid://cqaljfl16eh4d")
@export var damage_range_curve: Curve = preload("uid://bonbeehw3fa7s")
@export var health_curve: Curve = preload("uid://dyo345vjfo34m")
@export var defense_curve: Curve = preload("uid://j28agwrmkxbx")


# func _apply_level_scaling() -> void:
# 	@warning_ignore_start("narrowing_conversion")
# 	stats.base_physical_damage *= damage_curve.sample(level)
# 	stats.base_fire_damage *= damage_curve.sample(level)
# 	stats.base_cold_damage *= damage_curve.sample(level)
# 	stats.base_lightning_damage *= damage_curve.sample(level)
# 	stats.base_chaos_damage *= damage_curve.sample(level)
	
# 	stats.base_physical_damage_range *= damage_range_curve.sample(level)
# 	stats.base_fire_damage_range *= damage_range_curve.sample(level)
# 	stats.base_cold_damage_range *= damage_range_curve.sample(level)
# 	stats.base_lightning_damage_range *= damage_range_curve.sample(level)
# 	stats.base_chaos_damage *= damage_range_curve.sample(level)
	
# 	stats.base_max_health = health_curve.sample(level)
	
# 	stats.base_evasion = defense_curve.sample(level)
# 	stats.base_max_energy_shield = defense_curve.sample(level)

func _apply_level_scaling() -> void:
	if stats == null:
		return

	var damage_mult := damage_curve.sample(level)
	var damage_range_mult := damage_range_curve.sample(level)
	var health_mult := health_curve.sample(level)
	var defense_mult := defense_curve.sample(level)

	stats.base_physical_damage = int(round(stats.base_physical_damage * damage_mult))
	stats.base_physical_damage_range = int(round(stats.base_physical_damage_range * damage_range_mult))
	stats.base_fire_damage = int(round(stats.base_fire_damage * damage_mult))
	stats.base_fire_damage_range = int(round(stats.base_fire_damage_range * damage_range_mult))
	stats.base_cold_damage = int(round(stats.base_cold_damage * damage_mult))
	stats.base_cold_damage_range = int(round(stats.base_cold_damage_range * damage_range_mult))
	stats.base_lightning_damage = int(round(stats.base_lightning_damage * damage_mult))
	stats.base_lightning_damage_range = int(round(stats.base_lightning_damage_range * damage_range_mult))
	stats.base_chaos_damage = int(round(stats.base_chaos_damage * damage_mult))
	stats.base_chaos_damage_range = int(round(stats.base_chaos_damage_range * damage_range_mult))

	stats.base_max_health = int(round(stats.base_max_health * health_mult))
	stats.base_evasion = int(round(stats.base_evasion * defense_mult))
	stats.base_max_energy_shield = int(round(stats.base_max_energy_shield * defense_mult))
	stats.recalculate_stats()