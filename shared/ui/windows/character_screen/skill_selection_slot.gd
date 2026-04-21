class_name SkillSelectionSlot
extends Control


signal slot_selected(slot)

static var hovered_slot: SkillSelectionSlot = null

@onready var highlight: TextureRect = $Highlight
@onready var skill_icon: TextureRect = $SkillIcon

@export var skill: SkillData = null:
	set(new_value):
		skill = new_value
		if skill:
			skill_icon.texture = skill.skill_icon
		else:
			skill_icon.texture = null


func _gui_input(event):
	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed:
		slot_selected.emit(self )


func _on_mouse_entered() -> void:
	hovered_slot = self

	# Placeholder for Tooltip stuff


func _on_mouse_exited() -> void:
	if hovered_slot == self:
		hovered_slot = null
	
	# Placeholder for Tooltip stuff