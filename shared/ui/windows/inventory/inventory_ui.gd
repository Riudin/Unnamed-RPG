class_name InventoryUI
extends Control


@export var slot_scene: PackedScene
@export var item_ui_scene: PackedScene

const CELL_SIZE := 22

var slots: Array[InventorySlot] = []

func _ready() -> void:
	InventoryManager.register_ui(self )
	_create_slots()

	if InventoryManager.grid:
		for i in InventoryManager.grid:
			var item = InventoryManager.grid[i]
			var pos = InventoryManager.grid.find_key(item)
			spawn_item_ui(item, pos)


func _create_slots():
	custom_minimum_size = InventoryManager.GRID_SIZE * CELL_SIZE
	
	for y in range(InventoryManager.GRID_SIZE.y):
		for x in range(InventoryManager.GRID_SIZE.x):
			var s: InventorySlot = slot_scene.instantiate()
			s.grid_pos = Vector2i(x, y)
			s.position = Vector2i(x, y) * CELL_SIZE
			add_child(s)
			slots.append(s)


func spawn_item_ui(item: ItemInstance, pos: Vector2i):
	var ui := item_ui_scene.instantiate()
	add_child(ui)

	ui.setup(item)
	ui.grid_pos = pos
	ui.position = pos * CELL_SIZE
	

func _get_slot_at(pos: Vector2i) -> InventorySlot:
	for s in slots:
		if s.grid_pos == pos:
			return s
	return null
