extends Node


var active_dots: Array = []
var active_dot_sources: Array[DamageData] = []


func apply_damage(damage_data: DamageData, attacker_attributes: AttributeData, defender_attributes: AttributeData, target: Node) -> void:
	# base damage + scaling through attributes
	var base_damage = randf_range(damage_data.base_min_damage, damage_data.base_max_damage) + damage_data.flat_added_damage
	var scaling_bonus = _get_attribute_scaling(damage_data, attacker_attributes)
	var scaled_damage = base_damage * (1.0 + scaling_bonus)

	# general increased and more damage
	var increased_mult = 1.0 + (damage_data.increased_damage_pct / 100.0)
	var more_mult = damage_data.more_damage_multiplier
	var modified_damage = scaled_damage * increased_mult * more_mult

	# increases to type of dmg (e.g. if physical then apply increased physical dmg)
	var element_bonus = attacker_attributes.get_damage_bonus_for_type(damage_data.damage_type) / 100.0
	modified_damage *= (1.0 + element_bonus)

	# determine if crit and apply crit dmg
	var is_crit = randf() <= (damage_data.crit_chance_pct / 100.0 + attacker_attributes.crit_chance_pct / 100.0)
	if is_crit:
		modified_damage *= damage_data.crit_multiplier * attacker_attributes.crit_damage_multiplier
	
	# apply mitigation from defender
	var mitigated = _apply_mitigation(modified_damage, damage_data.damage_type, defender_attributes)

	# do damage to target
	if target.has_method("take_damage"):
		target.take_damage(mitigated, damage_data, is_crit)
	elif target.health_component and target.health_component.has_method("take_damage"):
		target.health_component.take_damage(mitigated, damage_data, is_crit)
	
	# apply dot
	if damage_data.applies_dot:
		_apply_dot_effect(damage_data, attacker_attributes, defender_attributes, target)


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


func _apply_dot_effect(damage_data: DamageData, _attacker: AttributeData, defender: AttributeData, target: Node) -> void:
	if not is_instance_valid(target):
		return
	
	var dot = {
		"target": target,
		"type": damage_data.dot_id,
		"damage_type": damage_data.damage_type,
		"remaining_time": damage_data.dot_duration,
		"tick_interval": damage_data.dot_tick_interval,
		"tick_damage": _apply_mitigation(damage_data.dot_tick_damage, damage_data.damage_type, defender),
		"stacks": 1,
		"can_stack": damage_data.dot_can_stack,
		"max_stacks": damage_data.dot_max_stacks
	}

	# check if dot already exists
	for existing in active_dots:
		if existing.target == target and existing.type == damage_data.dot_id:
			# if it exists and can stack, increase damage
			if existing.can_stack:
				existing.stacks = min(existing.stacks + 1, existing.max_stacks)
				existing.tick_damage += dot.tick_damage
			# else reset time
			else:
				existing.remaining_time = damage_data.dot_duration
			return
	
	active_dots.append(dot)
	active_dot_sources.append(damage_data)


func _process(delta: float) -> void:
	for i in range(active_dots.size() - 1, -1, -1): # iterating backwards to avoid issues with removing dots
		var dot = active_dots[i]

		if not is_instance_valid(dot.target):
			active_dots.remove_at(i)
			active_dot_sources.remove_at(i)
			continue

		dot.remaining_time -= delta
		dot.tick_interval -= delta

		if dot.tick_interval <= 0.0:
			dot.tick_interval = active_dot_sources[i].dot_tick_interval
			if dot.target.has_method("take_damage"):
				var total_tick = dot.tick_damage * dot.stacks
				dot.target.take_damage(total_tick, active_dot_sources[i], false)
			elif dot.target.health_component and dot.target.health_component.has_method("take_damage"):
				var total_tick = dot.tick_damage * dot.stacks
				dot.target.health_component.take_damage(total_tick, active_dot_sources[i], false)

		if dot.remaining_time <= 0.0:
			active_dots.remove_at(i)
			active_dot_sources.remove_at(i)
