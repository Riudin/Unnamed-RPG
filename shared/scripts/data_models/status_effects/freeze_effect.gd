class_name FreezeEffect
extends StatusEffect


const ICON: Texture2D = preload("uid://62yt5adeawar")

@export var tick_interval: float = 1.0

var original_action_speed: float


func on_apply(target, _instance: StatusEffectInstance) -> void:
	if target == null:
		print("ChillEffect: target is null!")
		return
	
	if target.attack_component:
		original_action_speed = target.attack_component.action_speed
		target.attack_component.action_speed = 0.0


func on_expire(target) -> void:
	if target == null:
		print("ChillEffect: target is null!")
		return
	
	if target.attack_component:
		target.attack_component.action_speed = original_action_speed
