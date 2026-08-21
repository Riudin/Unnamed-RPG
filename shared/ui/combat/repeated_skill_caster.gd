class_name RepeatedSkillCaster
extends Node


var remaining_casts: int
var delay_between_hits: float
var attacker # just a helper to get access to the scene tree
var cast_callback: Callable


func start() -> void:
	_schedule_next_cast()


func _schedule_next_cast() -> void:
	var skill_timer = get_tree().create_timer(delay_between_hits)
	skill_timer.timeout.connect(_on_skill_timer_timeout)


func _on_skill_timer_timeout() -> void:
	print("firing skill ", remaining_casts)

	cast_callback.call()
	remaining_casts -= 1
	if remaining_casts <= 0:
		queue_free()
	else:
		_schedule_next_cast()
