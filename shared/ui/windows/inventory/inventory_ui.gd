class_name InventoryUI
extends Control


@export var slot_scene: PackedScene
@export var item_scene: PackedScene

const CELL_SIZE := 22

var slots: Array[InventorySlot] = []

func _ready() -> void:
	InventoryManager.register_ui(self )
	_create_slots()


func _create_slots():
	for y in range(InventoryManager.GRID_SIZE.y):
		for x in range(InventoryManager.GRID_SIZE.x):
			var s: InventorySlot = slot_scene.instantiate()
			s.grid_pos = Vector2i(x, y)
			s.position = Vector2(x, y) * CELL_SIZE
			add_child(s)
			slots.append(s)


func spawn_item_ui(item: ItemInstance, pos: Vector2i):
	var ui := item_scene.instantiate()
	add_child(ui)

	ui.setup(item)
	ui.grid_pos = pos
	ui.position = pos * CELL_SIZE


func _get_slot_at(pos: Vector2i) -> InventorySlot:
	for s in slots:
		if s.grid_pos == pos:
			return s
	return null
