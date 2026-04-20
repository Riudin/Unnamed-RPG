class_name DeprAttributeData
extends Resource


# Primary Attributes
@export var strength: int = 0
@export var dexterity: int = 0
@export var intelligence: int = 0
@export var vitality: int = 0

# Resources
@export var max_health: int = 100
@export var max_mana: int = 50
@export var max_energy_shield: int = 0
@export var max_stamina: int = 100

@export var life_regen: int = 0
@export var mana_regen: int = 0
@export var enery_shield_regen: int = 0
@export var stamina_regen: int = 0

# Damage increases in percent (i.e. +% increased physical damage)
@export var physical_damage_pct: int = 0
@export var elementatl_damage_pct: int = 0
@export var fire_damage_pct: int = 0
@export var cold_damage_pct: int = 0
@export var lightning_damage_pct: int = 0
@export var chaos_damage_pct: int = 0
@export var holy_damage_pct: int = 0
@export var poison_damage_pct: int = 0

# Speed
@export var base_attack_speed: float = 1.0
@export var attack_speed_pct: int = 0
@export var cast_speed_pct: int = 0

# Critical Hilts
@export var crit_chance_pct: int = 0
@export var crit_damage_multiplier: float = 1.5 # Maybe turn into int?

# Accuracy and Penetration
@export var accuracy_rating: int = 0
@export var penetration_pct: int = 0

# Defensive Stats
@export var armor: int = 0
@export var evasion: int = 0
@export var block_chance_pct: int = 0
@export var dodge_chance_pct: int = 0
@export var fire_resist_pct: int = 0
@export var cold_resist_pct: int = 0
@export var lightning_resist_pct: int = 0
@export var chaos_resist_pct: int = 0
@export var all_resist_pct: int = 0

@export var damage_reduction_pct: int = 0
@export var life_leech_pct: int = 0
@export var mana_leech_pct: int = 0
@export var enery_shield_leech_pct: int = 0

@export var bleed_resist_pct: int = 0
@export var poison_resist_pct: int = 0
@export var burn_resist_pct: int = 0
@export var freeze_resist_pct: int = 0

# Miscellaneous Attributes
@export var move_speed_pct: int = 0
@export var cooldown_reduction_pct: int = 0
@export var mana_cost_reduction_pct: int = 0
@export var item_find_pct: int = 0
@export var gold_find_pct: int = 0

# Primary Attributes scaling (1.0 == plus 1 to the property per point in Attribute)
@export var strength_damage_scaling: float = 1
@export var dexterity_crit_scaling: float = 1
@export var intelligence_elemental_scaling: float = 1.0
@export var intelligence_mana_scaling: float = 0.5
@export var vitality_health_scaling: float = 1.0


func get_total_health() -> int:
	return max_health + int((vitality * vitality_health_scaling))


func get_total_mana() -> int:
	return max_mana + int((intelligence * intelligence_mana_scaling))


func get_damage_bonus_for_type(damage_type: String) -> int:
	match damage_type:
		"Physical": return physical_damage_pct
		"Fire": return fire_damage_pct + elementatl_damage_pct
		"Cold": return cold_damage_pct + elementatl_damage_pct
		"Lightning": return lightning_damage_pct + elementatl_damage_pct
		"Chaos": return chaos_damage_pct
		"Holy": return holy_damage_pct
		"Poison": return poison_damage_pct
		_: return 0


func get_attack_speed() -> float:
	return base_attack_speed + base_attack_speed * (attack_speed_pct / 100.0)


func to_dict() -> Dictionary:
	var data := {}
	for p in get_property_list():
		if p.usage & PROPERTY_USAGE_EDITOR:
			data[p.name] = get(p.name)
	
	return data


func from_dict(data: Dictionary) -> void:
	for key in data:
		if key == "script":
			continue

		if key in self:
			set(key, data[key])