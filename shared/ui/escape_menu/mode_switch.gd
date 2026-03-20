extends VBoxContainer


@onready var save_slots: Control = %SaveSlots


func _on_save_button_pressed() -> void:
	for slot in save_slots.get_children():
		if "mode" in slot:
			slot.mode = slot.MODE.SAVE
	
	_show_save_slots()


func _on_load_button_pressed() -> void:
	for slot in save_slots.get_children():
		if "mode" in slot:
			slot.mode = slot.MODE.LOAD
	
	_show_save_slots()


func _show_save_slots():
	visible = false
	save_slots.visible = true