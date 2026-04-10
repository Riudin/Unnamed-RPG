class_name HealthComponent
extends Node


var health: float
var max_health: float

@onready var parent := get_parent()

@onready var damage_popup_position: Vector2 = parent.global_position

@export var parent_data: Resource = null # player_data or enemy_data

signal health_changed(new_health)
signal died(body)


func _ready() -> void:
	await get_parent().ready
	max_health = parent_data.base_attributes.get_total_health()
	health = max_health


func take_damage(damage, is_crit):
	health -= damage
	health = clamp(health, 0.0, max_health)
	emit_signal("health_changed", health)

	DamagePopupManager.spawn(
		damage,
		damage_popup_position,
		#DamagePopupManager.damage_colors[damage_source.damage_type],
		Color.WHITE,
		is_crit
	)

	if health <= 0.0:
		died.emit(parent)
