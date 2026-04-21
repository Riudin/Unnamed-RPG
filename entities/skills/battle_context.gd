class_name BattleContext
extends RefCounted

### Holds the context for the execution of actions in battle and manages that execution. Can potentially also give information about the context of a battle
### Takes information from combatants and used skills and builds damage instance from that


var attacker
var defender
var attacker_stats: Stats = null


func build_damage_instance() -> DamageInstance:
	var instance = DamageInstance.new()

	instance.stats = attacker_stats

	instance.attacker = attacker
	instance.defender = defender

	return instance


func determine_crit(instance: DamageInstance) -> bool:
	var is_crit: bool = DamageSystem.resolve_crit(instance)

	return is_crit


func deal_damage(instance: DamageInstance, is_crit: bool) -> int:
	#var is_crit: bool = DamageSystem.resolve_crit(instance)
	var dmg: int = DamageSystem.resolve(instance, is_crit)
	print("------Total Damage: ", dmg)
	
	if instance.defender and instance.defender.health_component.has_method("take_damage"):
		instance.defender.health_component.take_damage(dmg, is_crit)
	
	return dmg
