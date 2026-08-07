extends Node2D


signal clicked

var dungeon_data = null # TODO: add data to send with the signal

func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if not event.is_action_pressed("left_click"):
		return
	
	clicked.emit(dungeon_data)
