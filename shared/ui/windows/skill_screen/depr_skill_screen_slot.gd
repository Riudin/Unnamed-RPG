class_name SkillScreenSlot
extends Control


@export var skill: SkillData

@onready var skill_icon: TextureRect = %SkillIcon


func _get_drag_data(_pos):
	var drag_texture = TextureRect.new()
	drag_texture.texture = skill_icon.texture
	drag_texture.size = Vector2(16, 16)

	var control = Control.new()
	control.add_child(drag_texture)
	drag_texture.position = -0.5 * drag_texture.size
	set_drag_preview(control)

	return skill


func _can_drop_data(_pos, data):
	return false


func _drop_data(_pos, data):
	pass
