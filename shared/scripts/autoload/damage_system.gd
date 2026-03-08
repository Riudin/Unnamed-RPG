extends Node


var active_dots: Array = []
var active_dot_sources: Array[DamageData] = []


func apply_damage(damage_data: DamageData, attacker_attributes: AttributeData, defender_attributes: AttributeData, target: BattleEntity) -> void:
	var base_damage = randf_range(damage_data.base_min_damage, damage_data.base_max_damage) + damage_data.flat_added_damage
	var scaling_bonus = _get_attribute_scaling(damage_data, attacker_attributes)
	var scaled_damage = base_damage * (1.0 + scaling_bonus)

	var increased_mult = 1.0 + (damage_data.increased_damage_pct / 100.0)
	var more_mult = damage_data.more_damage_multiplier
	var modified_damage = scaled_damage * increased_mult * more_mult

	var element_bonus = attacker_attributes.get_damage_bonus_for_type(damage_data.damage_type) / 100.0
	modified_damage *= (1.0 + element_bonus)

	var is_crit = randf() <= (damage_data.crit_chance_pct / 100.0 + attacker_attributes.crit_chance_pct / 100.0)
	if is_crit:
		modified_damage *= damage_data.crit_multiplier * attacker_attributes.crit_damage_multiplier
	
	var mitigated = _apply_mitigation(modified_damage, damage_data.damage_type, defender_attributes)

	if target.has_method("take_damage"):
		target.take_damage(mitigated, damage_data, is_crit)
	elif target.health_component and target.health_component.has_method("take_damage"):
		target.health_component.take_damage(mitigated, damage_data, is_crit)


func _get_attribute_scaling(damage_data: DamageData, attributes: AttributeData) -> float:
	match damage_data.damage_type:
		"Physical":
			return attributes.strength * (attributes.strength_damage_scaling / 100.0)
		"Fure", "Cold", "Lightning":
			return attributes.intelligence * (attributes.intelligence_elemental_scaling / 100.0)
		"Poinson", "Bleed":
			return attributes.dexterity * (attributes.dexterity_crit_scaling / 100.0)
		"Chaos":
			return (attributes.intelligence + attributes.dexterity) * 0.002
		_:
			return 0.0


func _apply_mitigation(damage: float, dmg_type: String, defender: AttributeData):
	var final_damage = damage

	match dmg_type:
		"Physical":
			final_damage *= (1.0 - defender.armor / (defender.armor + 400.0))
		"Fire":
			final_damage *= (1.0 - clamp((defender.fire_resist_pct + defender.all_resist_pct) / 100.0, 0.0, 0.9))
		"Cold":
			final_damage *= (1.0 - clamp((defender.cold_resist_pct + defender.all_resist_pct) / 100.0, 0.0, 0.9))
		"Lightning":
			final_damage *= (1.0 - clamp((defender.lightning_resist_pct + defender.all_resist_pct) / 100.0, 0.0, 0.9))
		"Chaos":
			final_damage *= (1.0 - clamp(defender.chaos_resist_pct / 100.0, 0.0, 0.9))
		"Poison":
			final_damage *= (1.0 - clamp(defender.poison_resist_pct / 100.0, 0.0, 1.0))
		"Bleed":
			final_damage *= (1.0 - clamp(defender.bleed_resist_pct / 100.0, 0.0, 1.0))
		"Burn":
			final_damage *= (1.0 - clamp(defender.burn_resist_pct / 100.0, 0.0, 1.0))
		"Freeze":
			final_damage *= (1.0 - clamp(defender.freeze_resist_pct / 100.0, 0.0, 1.0))
		
	return max(0.0, final_damage)
