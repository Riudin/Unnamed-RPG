class_name HealthComponent
extends Node


# signal health_changed(new_health)
signal died(body)

var health: float
var max_health: float
var parent_data: Resource = null # player_data or enemy_data

@export var health_bar: StatBar = null

var damage_taken_modifier: float = 1.0

@onready var parent := get_parent()
@onready var health_bar_label: Label = %HealthBarLabel
#@onready var mana_bar_label: Label = %ManaBarLabel


func _ready() -> void:
	await get_parent().ready
	max_health = parent_data.stats.current_max_health
	health = max_health

	health_bar.setup_bar(health, max_health)
	if health_bar_label:
		health_bar_label.text = str(int(health)) + " / " + str(int(max_health))


func take_damage(damage: int):
	health -= int(damage * damage_taken_modifier)
	health = clampf(health, 0.0, max_health)

	if health_bar:
		health_bar.update_bar(float(health), float(max_health))
	
	if health_bar_label:
		health_bar_label.text = str(int(health)) + " / " + str(int(max_health))

	if health <= 0.0:
		died.emit(parent)


# func on_visual_hit():
# 	if health_bar:
# 		health_bar.update_bar(float(health), float(max_health))
