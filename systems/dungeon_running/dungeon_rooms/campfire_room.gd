extends Control


func _on_button_pressed() -> void:
	SignalBus.campfire_room_exited.emit()