class_name SkillSelectionBar
extends HBoxContainer


var slots: Array[SkillSelectionSlot] = []
var selected_slot: SkillSelectionSlot = null

@onready var skill_selection_slot_1: Control = %SkillSelectionSlot1
@onready var skill_selection_slot_2: Control = %SkillSelectionSlot2
@onready var skill_selection_slot_3: Control = %SkillSelectionSlot3
@onready var skill_selection_slot_4: Control = %SkillSelectionSlot4
@onready var skill_selection_slot_5: Control = %SkillSelectionSlot5


func _ready() -> void:
	skill_selection_slot_1.slot_selected.connect(_on_sot_selected)
	skill_selection_slot_2.slot_selected.connect(_on_sot_selected)
	skill_selection_slot_3.slot_selected.connect(_on_sot_selected)
	skill_selection_slot_4.slot_selected.connect(_on_sot_selected)
	skill_selection_slot_5.slot_selected.connect(_on_sot_selected)

	slots.append(skill_selection_slot_1)
	slots.append(skill_selection_slot_2)
	slots.append(skill_selection_slot_3)
	slots.append(skill_selection_slot_4)
	slots.append(skill_selection_slot_5)

	selected_slot = skill_selection_slot_1
	skill_selection_slot_1.highlight.show()

	update_slots()


func _on_sot_selected(slot: SkillSelectionSlot) -> void:
	for s in slots:
		s.highlight.hide()

	selected_slot = slot
	GameState.player_data.active_skill = slot.skill
	slot.highlight.show()


func update_slots() -> void:
	for i in slots.size():
		if GameState.player_data.equipped_skills[i]:
			slots[i].skill = GameState.player_data.equipped_skills[i]
		else:
			slots[i].skill = null


func _on_visibility_changed() -> void:
	update_slots()
