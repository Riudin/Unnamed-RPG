extends Control



func _on_button_pressed() -> void:
	SignalBus.shrine_room_exited.emit()
