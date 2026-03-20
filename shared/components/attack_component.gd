class_name AttackComponent
extends Node


signal progress_changed(progress: float)

var attack_interval_ticks: int = 0
var tick_counter: int = 0

@onready var parent = get_parent()
var target: Node

@export var damages: Array[DamageData] = []
@export var default_damage: DamageData


func _ready() -> void:
	await get_parent().ready
	TickManager.connect("tick", _on_tick)
	_calculate_attack_interval()


func _calculate_attack_interval() -> void:
	var attack_speed: float = parent.attribute_data.get_attack_speed()
	if parent.attribute_data and attack_speed > 0.0:
		# how many ticks must elapse between attacks
		attack_interval_ticks = int(ceil(TickManager.tick_rate / attack_speed)) # Note that ceil introduces breakpoints.
		# for example attackspeed of 6.7 and 7.4 both return 9 attack_interval_ticks. You'd need 7.5 attackspeed to get 8 attack_interval_ticks.
		# This is not clean because attack_speed should be == attacks per second. But it works for now.
	else:
		attack_interval_ticks = int(1e9) # effectively never
	
	tick_counter = 0
	emit_signal("progress_changed", 0.0)


func set_damages(list):
	damages.clear()

	if list == null:
		damages = [default_damage]
		return

	for d in list:
		damages.append(d.duplicate(true))


func _on_tick():
	if attack_interval_ticks <= 0: return
	if target == null:
		return

	tick_counter += 1

	# Calculate Progress
	var progress: float = float(tick_counter) / float(attack_interval_ticks)
	progress = clamp(progress, 0.0, 1.0)

	emit_signal("progress_changed", progress)

	# Attack
	if tick_counter >= attack_interval_ticks:
		tick_counter = 0
		
		for dmg in damages:
			DamageSystem.apply_damage(
				dmg,
				parent.attribute_data,
				target.attribute_data,
				target
				)

		emit_signal("progress_changed", 0.0)
