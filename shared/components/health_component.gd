class_name HealthComponent
extends Node


var health: float
var max_health: float

@onready var parent := get_parent()

signal health_changed(new_health)
signal died(body)


func _ready() -> void:
	max_health = parent.attribute_data.get_total_health()
	health = parent.attribute_data.get_total_health()


func take_damage(mitigated, damage_data: DamageData, is_crit):
	health -= mitigated
	health = clamp(health, 0.0, max_health)
	emit_signal("health_changed", health)

	DamagePopupManager.spawn(
		mitigated,
		parent.global_position,
		DamagePopupManager.damage_colors[damage_data.damage_type],
		is_crit
	)

	if health <= 0.0:
		died.emit(parent)
