class_name HealthComponent
extends Node


@export var health: float

@onready var parent := get_parent()

signal health_changed(new_health)
signal died


func _ready() -> void:
	health = parent.combat_stats.max_health


func take_damage(amount: float):
	health = clamp(health - amount, 0.0, parent.combat_stats.max_health)
	emit_signal("health_changed", health)

	if health <= 0.0:
		emit_signal("died")


# unused
func heal(amount: float):
	health = clamp(health + amount, 0.0, parent.combat_stats.max_health)
