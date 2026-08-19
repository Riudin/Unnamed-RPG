class_name ChillEffect
extends StatusEffect


const ICON: Texture2D = preload("uid://d1h0rsbqdke3j")

@export var tick_interval: float = 1.0
@export var action_speed_modifier: float = 0.7


func on_apply(target, _instance: StatusEffectInstance) -> void:
	if target == null:
		print("ChillEffect: target is null!")
		return
	
	if target.attack_component:
		target.attack_component.action_speed *= action_speed_modifier


func on_expire(target) -> void:
	if target == null:
		print("ChillEffect: target is null!")
		return
	
	if target.attack_component:
		target.attack_component.action_speed /= action_speed_modifier
