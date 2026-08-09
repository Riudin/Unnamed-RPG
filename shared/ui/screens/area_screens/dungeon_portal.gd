extends Control


signal clicked

var dungeon_data = null # TODO: add data to send with the signal

func _on_texture_rect_gui_input(event: InputEvent) -> void:
	if not event.is_action_pressed("left_click"):
		return
	
	clicked.emit(dungeon_data)
