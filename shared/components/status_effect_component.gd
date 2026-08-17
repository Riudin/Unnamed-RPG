class_name StatusEffectComponent
extends Node


var active_effects: Dictionary[String, StatusEffectInstance] = {} # {id: instance}


func _ready() -> void:
	TickManager.tick.connect(_on_tick)


func apply_effect(effect: StatusEffect, source) -> void:
	if active_effects.has(effect.id):
		var existing: StatusEffectInstance = active_effects[effect.id]
		existing.remaining_ticks = int(effect.duration * TickManager.TICK_RATE)
		existing.stacks = min(existing.stacks + 1, effect.max_stacks)
	else:
		var instance = StatusEffectInstance.new()
		instance.effect = effect
		instance.remaining_ticks = int(effect.duration * TickManager.TICK_RATE)
		instance.source = source
		if source is CombatEnemy:
			instance.stats_snapshot = source.enemy_data.stats.duplicate()
		elif source is CombatPlayer:
			instance.stats_snapshot = source.player_data.stats.duplicate()
		else:
			push_error("StatusEffectComponent: No enemy_data or player_data on ", source)
		active_effects[effect.id] = instance
		effect.on_apply(get_parent(), instance)


func has_effect(id: String) -> bool:
	return active_effects.has(id)


func remove_effect(id: String) -> void:
	if active_effects.has(id):
		active_effects[id].effect.on_expire(get_parent())
		active_effects.erase(id)


func _on_tick() -> void:
	for id in active_effects.keys():
		var instance = active_effects[id]
		instance.remaining_ticks -= 1
		instance.tick_accumulator += 1

		var interval_ticks = int(instance.effect.tick_interval * TickManager.TICK_RATE)
		if instance.tick_accumulator >= interval_ticks:
			instance.tick_accumulator = 0
			instance.effect.on_tick(get_parent(), instance)

		if instance.remaining_ticks <= 0:
			remove_effect(id)
