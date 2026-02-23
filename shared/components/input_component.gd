class_name InputComponent
extends Node2D


var follow_mouse := false

signal movement_input(target)


func _physics_process(_delta):
	if follow_mouse:
		var click_position := get_global_mouse_position()
		emit_signal("movement_input", click_position)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
			follow_mouse = event.pressed
