class_name AttackComponent
extends Node


signal progress_changed(progress: float)
signal attack_ready(target, damage_info)

var attack_interval_ticks: int = 0
var tick_counter: int = 0

@onready var parent = get_parent()
var target: BattleEntity


func _ready() -> void:
	TickManager.connect("tick", _on_tick)
	calculate_attack_interval()


func calculate_attack_interval() -> void:
	if parent.combat_stats and parent.attack_speed > 0.0:
		# how many ticks must elapse between attacks
		attack_interval_ticks = int(ceil(TickManager.tick_rate / parent.attack_speed)) # Note that ceil introduces breakpoints.
		# for example attackspeed of 6.7 and 7.4 both return 9 attack_interval_ticks. You'd need 7.5 attackspeed to get 8 attack_interval_ticks.
		# This is not clean because attack_speed should be == attacks per second. But it works for now.
	else:
		attack_interval_ticks = int(1e9) # effectively never
	
	tick_counter = 0
	emit_signal("progress_changed", 0.0)


func _on_tick():
	if attack_interval_ticks <= 0: return
	if target == null:
		print("No target found for ", self )
		return

	tick_counter += 1
	var progress: float = float(tick_counter) / float(attack_interval_ticks)
	progress = clamp(progress, 0.0, 1.0)

	emit_signal("progress_changed", progress)

	if tick_counter >= attack_interval_ticks:
		tick_counter = 0
		emit_signal("attack_ready", target, parent.calculate_damage_info())
		emit_signal("progress_changed", 0.0)