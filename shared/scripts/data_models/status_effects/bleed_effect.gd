class_name BleedEffect
extends StatusEffect


@export var damage_per_tick_modifier: float = 0.45
@export var tick_interval: float = 0.5 # how many seconds between damage ticks

const ICON: Texture2D = preload("uid://b2thebwrl1eus")


func on_tick(target, effect_instance: StatusEffectInstance) -> void:
	_deal_damage(target, effect_instance)


func _deal_damage(target, effect_instance: StatusEffectInstance) -> void:
	if target == null:
		print("BleedEffect: target is null!")
		return
		
	var dmg_instance = DamageInstance.new()
	dmg_instance.stats = Stats.new()
	dmg_instance.stats.current_physical_damage = effect_instance.stats_snapshot.current_physical_damage * damage_per_tick_modifier
	dmg_instance.stats.current_physical_damage_range = effect_instance.stats_snapshot.current_physical_damage_range * damage_per_tick_modifier
	dmg_instance.stats.current_chill_chance = 0 # needed (?) to avoid status effects applying chill
	dmg_instance.defender = target
	
	var is_crit: bool = false # status effects can't crit
	var damage_dealt: int = DamageSystem.resolve(dmg_instance, is_crit)

	if damage_dealt <= 0:
		return

	if dmg_instance.defender and dmg_instance.defender.health_component.has_method("take_damage"):
		dmg_instance.defender.health_component.take_damage(damage_dealt)

	if target:
		DamagePopupManager.spawn(
			int(damage_dealt),
			target.global_position,
			#DamagePopupManager.damage_colors[damage_source.damage_type],
			Color.INDIAN_RED,
			is_crit,
			0.8
			)
