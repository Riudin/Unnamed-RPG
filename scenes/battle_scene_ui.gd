extends CanvasLayer


func _on_pause_button_pressed() -> void:
	get_tree().paused = !get_tree().paused


func _on_half_speed_button_pressed() -> void:
	Engine.time_scale = 0.5


func _on_normal_speed_button_pressed() -> void:
	Engine.time_scale = 1.0


func _on_double_speed_button_pressed() -> void:
	Engine.time_scale = 2.0


func _on_5speed_button_pressed() -> void:
	Engine.time_scale = 5.0
