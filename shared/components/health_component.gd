class_name HealthComponent
extends Node


var health: float

@onready var parent := get_parent()

signal health_changed(new_health)
signal died


func _ready() -> void:
	health = parent.attribute_data.get_total_health()


func take_damage(mitigated, damage_data: DamageData, is_crit):
	health -= mitigated
	emit_signal("health_changed", health)

	if health <= 0.0:
		emit_signal("died")
