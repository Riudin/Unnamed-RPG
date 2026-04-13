class_name BattleContext
extends RefCounted

### Holds the context for the execution of actions in battle and manages that execution. Can potentially also give information about the context of a battle
### Takes information from combatants and used skills and builds damage instance from that


var attacker
var defender
var base_sources: Array[DamageSource]
var base_stats: StatBlock


func build_damage_instance(extra_sources: Array[DamageSource], skill_stats: StatBlock) -> DamageInstance:
	var instance = DamageInstance.new()

	#instance.sources = []
	instance.sources.append_array(base_sources)
	instance.sources.append_array(extra_sources)

	instance.stats = base_stats.combine(skill_stats)

	instance.attacker = attacker
	instance.defender = defender

	return instance


func deal_damage(instance: DamageInstance):
	var is_crit = DamageSystem.resolve_crit(instance)
	var dmg = DamageSystem.resolve(instance, is_crit)
	print("------Total Damage: ", dmg)
	
	if instance.defender and instance.defender.health_component.has_method("take_damage"):
		instance.defender.health_component.take_damage(dmg, is_crit)
