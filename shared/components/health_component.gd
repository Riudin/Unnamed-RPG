class_name HealthComponent
extends Node


var health: float
var max_health: float

@onready var parent := get_parent()

var parent_data: Resource = null # player_data or enemy_data

@export var health_bar: TextureProgressBar = null

# signal health_changed(new_health)
signal died(body)


func _ready() -> void:
	await get_parent().ready
	max_health = parent_data.base_attributes.get_total_health()
	health = max_health

	if health_bar:
		health_bar.max_value = max_health
		health_bar.value = health


func take_damage(damage, _is_crit):
	health -= damage
	health = clampf(health, 0.0, max_health)

	if health_bar:
		health_bar.value = health

	if health <= 0.0:
		died.emit(parent)
