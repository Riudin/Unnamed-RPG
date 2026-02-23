class_name InputComponent
extends Node2D


signal wants_move(target)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
			if event.pressed:
				emit_signal("wants_move", get_global_mouse_position())
