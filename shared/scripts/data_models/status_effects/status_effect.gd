class_name StatusEffect
extends Resource


@export var id: String = ""
@export var duration: float = 0.0
@export var max_stacks: int = 1


func on_apply(_target, _instance: StatusEffectInstance) -> void:
	pass


func on_tick(_target, _instance: StatusEffectInstance) -> void:
	pass


func on_expire(_target) -> void:
	pass
