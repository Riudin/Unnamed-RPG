class_name BurnEffect
extends StatusEffect


@export var damage_per_tick: int = 5
@export var tick_interval: float = 0.5 # how many seconds between damage ticks

# TODO: continue here! currently the status effect would deal all damage combined, not just burn. also the stats need to get passed around.
func on_tick(target, instance: StatusEffectInstance) -> void:
	var dmg_instance = DamageInstance.new()
	dmg_instance.stats = instance.stats_snapshot
	dmg_instance.defender = target
