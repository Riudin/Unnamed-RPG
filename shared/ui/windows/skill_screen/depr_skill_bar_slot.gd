class_name SkillBarSlot
extends Control


@export var skill: SkillData = null

var slot_id: int
@onready var skill_icon: TextureRect = %SkillIcon

signal skill_changed(slot_id, skill)


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
	return true


func _drop_data(_pos, data):
	skill = data
	skill_icon.texture = skill.skill_icon
	skill_changed.emit(slot_id, skill)
