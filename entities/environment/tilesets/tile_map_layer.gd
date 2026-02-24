extends TileMapLayer


@export var colliding_layers: Array[TileMapLayer]


func _use_tile_data_runtime_update(coords) -> bool:
	for layer in colliding_layers:
		# for id in layer.get_tile_set().get_source_count() - 1:
		if coords in layer.get_used_cells_by_id(0):
			return true
	return false


func _tile_data_runtime_update(coords: Vector2i, tile_data: TileData):
	for layer in colliding_layers:
		# for id in layer.get_tile_set().get_source_count() - 1:
		if coords in layer.get_used_cells_by_id(0):
			tile_data.set_navigation_polygon(0, null)
