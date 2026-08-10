extends Control


signal clicked

@export var dungeon_data: DungeonData = null

func _on_texture_rect_gui_input(event: InputEvent) -> void:
	if not event.is_action_pressed("left_click"):
		return
	
	clicked.emit(dungeon_data)
