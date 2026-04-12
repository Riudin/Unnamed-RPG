extends Node2D


@export var lifetime: float = 0.8
@export var rise_distance: float = 20.0
@onready var label: Label = %Label

var elapsed := 0.0
var velocity := Vector2(0, -30)

func show_value(value: int, color: Color, is_crit: bool = false):
	label.text = str(value)
	label.modulate = color
	if is_crit:
		label.scale = Vector2(1.3, 1.3)
		label.modulate = DamagePopupManager.damage_colors["Crit"]
	else:
		Vector2(1, 1)
	elapsed = 0.0


func _process(delta: float) -> void:
	elapsed += delta
	position += velocity * delta
	modulate.a = lerp(1.0, 0.0, elapsed / lifetime)

	if elapsed >= lifetime:
		hide()
		DamagePopupManager.recycle_popup(self )
