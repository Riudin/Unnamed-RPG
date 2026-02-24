class_name HealthComponent
extends Node


@export var health: float = 100.0

@onready var health_resource: HealthResource = HealthResource.new()

signal died

func _ready() -> void:
	health = health_resource.max_health


func heal(amount: float):
	health = clamp(health + amount, 0.0, health_resource.max_health)


func take_damage(amount: float):
	health = clamp(health - amount, 0.0, health_resource.max_health)
	
	if health <= 0.0:
		emit_signal("died")