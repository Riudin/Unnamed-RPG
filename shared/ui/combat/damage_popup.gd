extends Node2D


@export var lifetime: float = 1.4
@export var rise_distance: float = 50.0
@export var hold_time: float = 1.0 # Time to hold at peak before fading
@onready var label: Label = %Label

var elapsed := 0.0
var start_y: float
var target_y: float
var start_x: float
var target_x: float
var rise_duration: float


func show_value(value: int, color: Color, is_crit: bool = false):
	label.text = str(value)
	label.modulate = color
	if is_crit:
		label.scale = Vector2(1.3, 1.3)
		label.modulate = DamagePopupManager.damage_colors["Crit"]
	else:
		label.scale = Vector2(1, 1)
	elapsed = 0.0
	start_y = position.y
	target_y = position.y - rise_distance + randf_range(-15.0, 15.0)
	start_x = position.x
	target_x = position.x + randf_range(-15.0, 15.0)
	rise_duration = lifetime - hold_time


func _process(delta: float) -> void:
	elapsed += delta
	
	# Rise phase with ease-out curve
	if elapsed < rise_duration:
		var rise_progress = ease(elapsed / rise_duration, 0.5) # 0.5 = ease out
		position.y = lerp(start_y, target_y, rise_progress)
		position.x = lerp(start_x, target_x, rise_progress)
	else:
		# stay at target position
		position.y = target_y
		position.x = target_x
	
	# Fade out at the end
	modulate.a = lerp(1.0, 0.0, elapsed / lifetime)

	if elapsed >= lifetime:
		hide()
		DamagePopupManager.recycle_popup(self )
