class_name PoisonEffect
extends StatusEffect


@export var additional_chaos_dmg_pct: float = 0.5
@export var tick_interval: float = 0.5 # how many seconds between damage ticks

const ICON: Texture2D = preload("uid://ed5s7x655g1u")


func on_tick(target, effect_instance: StatusEffectInstance) -> void:
	_deal_damage(target, effect_instance)


func _deal_damage(target, effect_instance: StatusEffectInstance) -> void:
	if target == null:
		print("PoisonEffect: target is null!")
		return
		
	var dmg_instance = DamageInstance.new()
	dmg_instance.stats = Stats.new()
	dmg_instance.stats.current_poison_damage = effect_instance.stats_snapshot.current_poison_damage
	dmg_instance.stats.current_poison_damage_range = effect_instance.stats_snapshot.current_poison_damage_range
	dmg_instance.stats.current_chaos_damage = int(effect_instance.stats_snapshot.current_chaos_damage * additional_chaos_dmg_pct)
	dmg_instance.stats.current_chaos_damage_range = int(effect_instance.stats_snapshot.current_chaos_damage_range * additional_chaos_dmg_pct)
	dmg_instance.include_poison_damage = true
	dmg_instance.apply_status_effects = false
	dmg_instance.defender = target
	
	var is_crit: bool = false # status effects can't crit
	var damage_dealt: int = DamageSystem.resolve(dmg_instance, is_crit)
	
	if damage_dealt <= 0:
		return
		
	if dmg_instance.defender and dmg_instance.defender.health_component.has_method("take_damage"):
		dmg_instance.defender.health_component.take_damage(damage_dealt)

	if target:
		DamagePopupManager.spawn(
			int(damage_dealt * dmg_instance.defender.health_component.damage_taken_modifier),
			target.global_position,
			#DamagePopupManager.damage_colors[damage_source.damage_type],
			Color.WEB_GREEN,
			is_crit,
			0.8
			)
