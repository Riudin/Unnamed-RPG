class_name Stats
extends Resource


enum ModifiableStats {
	STRENGTH,
	DEXTERITY,
	INTELLIGENCE,
	VITALITY,
	MAX_HEALTH,
	MAX_MANA,
	MAX_ENERGY_SHIELD,
	LIFE_REGEN,
	MANA_REGEN,
	ENERY_SHIELD_REGEN,
	LIFE_LEECH,
	MANA_LEECH,
	ENERY_SHIELD_LEECH,
	PHYSICAL_DAMAGE,
	# PHYSICAL_DAMAGE_RANGE,
	ELEMENTAL_DAMAGE,
	# ELEMENTAL_DAMAGE_RANGE,
	FIRE_DAMAGE,
	# FIRE_DAMAGE_RANGE,
	COLD_DAMAGE,
	# COLD_DAMAGE_RANGE,
	LIGHTNING_DAMAGE,
	# LIGHTNING_DAMAGE_RANGE,
	CHAOS_DAMAGE,
	# CHAOS_DAMAGE_RANGE,
	ATTACK_SPEED,
	CAST_SPEED,
	CRIT_CHANCE,
	CRIT_MULTIPLIER,
	ACCURACY_RATING,
	PHYSICAL_PENETRATION,
	ELEMENTAL_PENETRATION,
	ARMOR,
	EVASION,
	BLOCK_CHANCE,
	DODGE_CHANCE,
	FIRE_RESIST,
	COLD_RESIST,
	LIGHTNING_RESIST,
	CHAOS_RESIST,
	ALL_RESIST,
	PHYSICAL_DAMAGE_REDUCTION,
	BLEED_RESIST,
	POISON_RESIST,
	BURN_RESIST,
	FREEZE_RESIST,
	MOVE_SPEED,
	MANA_COST_REDUCTION,
	ITEM_FIND,
	GOLD_FIND
}

signal stats_recalculated

# signal health_depleted
# signal health_changed(cur_health: int, max_health: int)

### Base Stats
# Primary Attributes
@export var base_strength: int = 10
@export var base_dexterity: int = 10
@export var base_intelligence: int = 10
@export var base_vitality: int = 10

# Resources
@export var base_max_health: int = 100
@export var base_max_mana: int = 50
@export var base_max_energy_shield: int = 0

@export var base_life_regen: int = 0
@export var base_mana_regen: int = 0
@export var base_enery_shield_regen: int = 0

@export var base_life_leech: int = 0
@export var base_mana_leech: int = 0
@export var base_enery_shield_leech: int = 0

# Damage stats
@export var base_physical_damage: int = 0
@export var base_physical_damage_range: int = 0
@export var base_elemental_damage: int = 0
@export var base_elemental_damage_range: int = 0
@export var base_fire_damage: int = 0
@export var base_fire_damage_range: int = 0
@export var base_cold_damage: int = 0
@export var base_cold_damage_range: int = 0
@export var base_lightning_damage: int = 0
@export var base_lightning_damage_range: int = 0
@export var base_chaos_damage: int = 0
@export var base_chaos_damage_range: int = 0

# Speed
@export var base_attack_speed: float = 1.0
@export var base_cast_speed: float = 1.0

# Critical Hilts
@export var base_crit_chance: int = 0
@export var base_crit_multiplier: int = 100

# Accuracy and Penetration
@export var base_accuracy_rating: int = 0
@export var base_physical_penetration: int = 0
@export var base_elemental_penetration: int = 0

# Defensive Stats
@export var base_armor: int = 0
@export var base_evasion: int = 0
@export var base_block_chance: int = 0
@export var base_dodge_chance: int = 0
@export var base_physical_damage_reduction: int = 0

@export var base_fire_resist: int = 0
@export var base_cold_resist: int = 0
@export var base_lightning_resist: int = 0
@export var base_chaos_resist: int = 0
@export var base_all_resist: int = 0


@export var base_bleed_resist: int = 0
@export var base_poison_resist: int = 0
@export var base_burn_resist: int = 0
@export var base_freeze_resist: int = 0

# Miscellaneous Attributes
@export var base_move_speed: int = 0
@export var base_mana_cost_reduction: int = 0
@export var base_item_find: int = 0
@export var base_gold_find: int = 0


### Derived Stats
# Primary Attributes
@export var current_strength: int = 0
@export var current_dexterity: int = 0
@export var current_intelligence: int = 0
@export var current_vitality: int = 0

# Resources
@export var current_max_health: int = 100
@export var current_max_mana: int = 50
@export var current_max_energy_shield: int = 0

@export var current_life_regen: int = 0
@export var current_mana_regen: int = 0
@export var current_enery_shield_regen: int = 0

@export var current_life_leech: int = 0
@export var current_mana_leech: int = 0
@export var current_enery_shield_leech: int = 0

# Damage stats
@export var current_physical_damage: int = 0
@export var current_physical_damage_range: int = 0
@export var current_elemental_damage: int = 0
@export var current_elemental_damage_range: int = 0
@export var current_fire_damage: int = 0
@export var current_fire_damage_range: int = 0
@export var current_cold_damage: int = 0
@export var current_cold_damage_range: int = 0
@export var current_lightning_damage: int = 0
@export var current_lightning_damage_range: int = 0
@export var current_chaos_damage: int = 0
@export var current_chaos_damage_range: int = 0

# Speed
@export var current_attack_speed: float = 1.0
@export var current_cast_speed: float = 1.0

# Critical Hilts
@export var current_crit_chance: int = 0
@export var current_crit_multiplier: int = 100

# Accuracy and Penetration
@export var current_accuracy_rating: int = 0
@export var current_physical_penetration: int = 0
@export var current_elemental_penetration: int = 0

# Defensive Stats
@export var current_armor: int = 0
@export var current_evasion: int = 0
@export var current_block_chance: int = 0
@export var current_dodge_chance: int = 0
@export var current_physical_damage_reduction: int = 0

@export var current_fire_resist: int = 0
@export var current_cold_resist: int = 0
@export var current_lightning_resist: int = 0
@export var current_chaos_resist: int = 0
@export var current_all_resist: int = 0

@export var current_bleed_resist: int = 0
@export var current_poison_resist: int = 0
@export var current_burn_resist: int = 0
@export var current_freeze_resist: int = 0

# Miscellaneous Attributes
@export var current_move_speed: int = 0
@export var current_mana_cost_reduction: int = 0
@export var current_item_find: int = 0
@export var current_gold_find: int = 0


### Variable Stats
# var health: int = 0 : set = _on_health_set
@export var experience: int = 0: set = _on_experience_set

var level: int:
	get(): return floor(max(1.0, sqrt(experience / 100.0) + 0.5))

var combined_damage: int = 0:
	get():
		return current_physical_damage + current_fire_damage + current_cold_damage + current_lightning_damage + current_chaos_damage
var combined_damage_range: int = 0:
	get():
		return current_physical_damage_range + current_fire_damage_range + current_cold_damage_range + current_lightning_damage_range + current_chaos_damage_range

var stat_modifiers: Array[StatModifier] = []


# Primary Attributes scaling (1.0 == plus 1 to the property per point in Attribute)
@export var strength_damage_scaling: float = 1.0
@export var dexterity_crit_scaling: float = 1.0
@export var intelligence_elemental_scaling: float = 1.0
@export var intelligence_mana_scaling: float = 0.5
@export var vitality_health_scaling: float = 1.0


func _init() -> void:
	setup_stats.call_deferred()


func setup_stats() -> void:
	stat_modifiers.clear()
	recalculate_stats()
	# health = current_max_health


func add_modifier(mod: StatModifier) -> void:
	stat_modifiers.append(mod)
	recalculate_stats.call_deferred()


func remove_modifier(mod: StatModifier) -> void:
	stat_modifiers.erase(mod)
	recalculate_stats.call_deferred()


func recalculate_stats() -> void:
	# Reset all current values to their respective base values
	for stat in get_property_list():
		if stat["name"].begins_with("current_"):
			var base_name = stat["name"].replace("current_", "base_")
			if get(base_name) != null:
				set(stat["name"], get(base_name))
			else:
				print("No base_ version found for ", stat["name"])

	var stat_addends: Dictionary[String, float] = {}
	var stat_multipliers: Dictionary[String, float] = {}
	var stat_more_multipliers: Dictionary[String, float] = {}
	for mod in stat_modifiers:
		var stat_name: String = ModifiableStats.keys()[mod.stat].to_lower()
		match mod.type:
			StatModifier.ModifierType.ADD:
				if not stat_addends.has(stat_name):
					stat_addends[stat_name] = 0.0
				stat_addends[stat_name] += mod.amount

			StatModifier.ModifierType.ADD_RANGE:
				if not stat_addends.has(stat_name):
					stat_addends[stat_name] = 0.0
				stat_addends[stat_name] += mod.amount

				if not stat_addends.has(stat_name + "_range"):
					stat_addends[stat_name + "_range"] = 0.0
				stat_addends[stat_name + "_range"] += mod.range_amount
			
			StatModifier.ModifierType.MULTIPLY:
				if not stat_multipliers.has(stat_name):
					stat_multipliers[stat_name] = 1.0
				stat_multipliers[stat_name] += mod.amount

			StatModifier.ModifierType.MORE:
				if not stat_more_multipliers.has(stat_name):
					stat_more_multipliers[stat_name] = 1.0
				stat_more_multipliers[stat_name] *= mod.amount

	for stat_name in stat_addends:
		var cur_property_name: String = str("current_" + stat_name)
		set(cur_property_name, get(cur_property_name) + stat_addends[stat_name])

	for stat_name in stat_multipliers:
		var cur_property_name: String = str("current_" + stat_name)
		set(cur_property_name, get(cur_property_name) * stat_multipliers[stat_name])

	for stat_name in stat_more_multipliers:
		var cur_property_name: String = str("current_" + stat_name)
		set(cur_property_name, get(cur_property_name) * stat_more_multipliers[stat_name])
	
	stats_recalculated.emit()


# func _on_health_set(new_value: int) -> void:
# 	health = clampi(new_value, 0, current_max_health)
#	health_changed.emit(health, current_max_health)
# 	if health <= 0:
# 		health_depleted.emit()


func _on_experience_set(new_value: int) -> void:
	var old_level: int = level
	experience = new_value
	
	if old_level != level:
		recalculate_stats()
