class_name ShockEffect
extends StatusEffect


const ICON: Texture2D = preload("uid://b0vbomij8y4t2")

@export var tick_interval: float = 1.0
@export var damage_taken_modifier: float = 1.9

var original_damage_taken_modifier: float

func on_apply(target, _instance: StatusEffectInstance) -> void:
	if target == null:
		print("ShockEffect: target is null!")
		return
	
	if target.health_component:
		original_damage_taken_modifier = target.health_component.damage_taken_modifier
		target.health_component.damage_taken_modifier = damage_taken_modifier


func on_expire(target) -> void:
	if target == null:
		print("ChillEffect: target is null!")
		return
	
	if target.health_component:
		target.health_component.damage_taken_modifier = original_damage_taken_modifier
