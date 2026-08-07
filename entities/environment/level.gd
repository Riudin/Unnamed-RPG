class_name Level
extends Node2D


@export var spawn_areas: Array[SpawnArea] = []
@export var area_entrances: Array[Node2D] = []


func _on_forest_area_entrance_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if not event.is_action_pressed("left_click"):
		return
	
	# insert any checks here if area can be entered
	SignalBus.forest_area_entry_requested.emit()
