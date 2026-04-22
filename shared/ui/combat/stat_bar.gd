class_name StatBar
extends Control


@onready var back_bar: TextureProgressBar = %BackBar
@onready var front_bar: TextureProgressBar = %FrontBar

@export var low_hp_pulse: bool = true
@export var damage_shake: bool = true
@export var damage_flash: bool = true
@export var heal_flash: bool = true

var current_pct := 1.0
var front_tween: Tween
var back_tween: Tween
var pulse_tween: Tween = null


func setup_bar(current: float, max_value: float) -> void:
	back_bar.max_value = max_value
	back_bar.value = current
	front_bar.max_value = max_value
	front_bar.value = current


func update_bar(current: float, max_value: float):
	var pct = clamp(current / max_value, 0.0, 1.0)

	back_bar.max_value = max_value
	front_bar.max_value = max_value

	var is_damage = pct < current_pct
	var is_heal = pct > current_pct

	if is_damage:
		if front_tween and front_tween.is_running():
			front_tween.kill()
		if back_tween and back_tween.is_running():
			back_tween.kill()
		
		front_bar.value = current

		back_tween = create_tween()
		back_tween.tween_property(back_bar, "value", current, 0.45)

		_on_damage()

	elif is_heal:
		if front_tween and front_tween.is_running():
			front_tween.kill()
		if back_tween and back_tween.is_running():
			back_tween.kill()
		
		front_tween = create_tween().set_parallel()
		front_tween.tween_property(front_bar, "value", current, 0.25)
		front_tween.tween_property(back_bar, "value", current, 0.25)

		_on_heal()

	current_pct = pct

	if low_hp_pulse:
		_check_low_hp_pulse(pct)
 

func _shake():
	var original_pos = position
	var tw = create_tween()
	tw.tween_property(self , "position", original_pos + Vector2(2, 0), 0.05)
	tw.tween_property(self , "position", original_pos - Vector2(2, 0), 0.05)
	tw.tween_property(self , "position", original_pos, 0.05)
 

func _flash(flash_color: Color):
	modulate = flash_color
	var t = create_tween()
	t.tween_property(self , "modulate", Color(1, 1, 1), 0.25)
 

func _on_damage():
	if damage_flash:
		_flash(Color(1, 0.3, 0.3))
	if damage_shake:
		_shake()
 

func _on_heal():
	if heal_flash:
		_flash(Color(0.3, 1, 0.3))
 

func _check_low_hp_pulse(pct: float) -> void:
	if pct < 0.25:
		if pulse_tween == null or not pulse_tween.is_running():
			if pulse_tween:
				pulse_tween.kill()
 
			pulse_tween = create_tween()
			pulse_tween.set_loops()
			pulse_tween.tween_property(self , "scale", Vector2(1.04, 1.04), 0.2)
			pulse_tween.tween_property(self , "scale", Vector2(1.00, 1.00), 0.2)
	else:
		scale = Vector2.ONE
 
		if pulse_tween and pulse_tween.is_running():
			pulse_tween.kill()
			pulse_tween = null