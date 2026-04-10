extends Node


var damage_colors := {
	"Physical": Color.WHITE,
	"Fire": Color(1, 0.3, 0.1),
	"Cold": Color(.4, 0.8, 1.0),
	"Lightning": Color(1, 1, 0.3),
	"Chaos": Color(0.6, 0.1, 0.8),
	"Poison": Color(0.1, 1.0, 0.1),
	"Bleed": Color(0.609, 0.0, 0.147, 1.0),
	"Burn": Color(1.0, 0.4, 0.0),
	"Freeze": Color(0.5, 0.7, 1.0),
	"DoT": Color(0.9, 0.5, 0.1),
	"Crit": Color(1.0, 0.0, 0.202, 1.0)
}

@onready var popup_scene: PackedScene = preload("uid://dbo3favm4c80p")
var pool: Array = []
var active: Array = []

signal damage_popup_ready(popup)


func _get_popup():
	if pool.size() > 0:
		var popup = pool.pop_back()
		popup.visible = true
		popup.modulate.a = 1.0
		return popup
	
	return popup_scene.instantiate()


func recycle_popup(popup):
	if active.has(popup):
		active.erase(popup)
	pool.append(popup)
	popup.visible = false


func spawn(value: int, world_position: Vector2, color: Color, is_crit := false):
	var popup = _get_popup()

	if popup.get_parent():
		popup.get_parent().remove_child(popup)
	
	add_child(popup)
	#emit_signal("damage_popup_ready", popup)

	popup.global_position = world_position + Vector2(randf_range(-4, 4), -16)
	popup.show_value(value, color, is_crit)

	active.append(popup)
