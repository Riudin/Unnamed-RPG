extends Control


func _on_change_skills_button_pressed() -> void:
	pass # Replace with function body.


func _on_continue_button_pressed() -> void:
		SignalBus.campfire_room_exited.emit()
