class_name InventoryUI
extends Control


@export var slot_scene: PackedScene
@export var item_scene: PackedScene

@onready var item_info_pop = $ItemInfoPop

var current_focus_item :set = _new_focus

const CELL_SIZE := 22

var slots: Array[InventorySlot] = []

# @onready var inventory_slot_grid: GridContainer = %InventorySlotGrid

# var inventory_size: int = 6
# var inventory_items: Array[ItemInstance] = []


func _ready() -> void:
	InventoryManager.register_ui(self )
	_create_slots()
	# visible = false

# 	InventoryManager.items_changed.connect(_on_items_changed)


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


func _new_focus(new):
	current_focus_item = new
	if new:
		var item = new.item
		var slot = _get_slot_at(new.grid_pos)
		var pos = slot.global_position
		pos.x = pos.x + CELL_SIZE
		item_info_pop._show_pop(item, pos)
		
	else:
		item_info_pop._hide_pop()

	

# func _on_items_changed(new_items: Array[ItemInstance]):
# 	if new_items.size() > inventory_size:
# 			print("Inventory full!")
# 			return
	
# 	# Adding Items to Inventory Slot Grid
# 	for item in new_items:
# 		# No need to change Items that are already there
# 		if inventory_items.has(item):
# 			continue
# 		# Add new slot containing new item
# 		else:
# 			var new_slot: InventorySlot = slot_scene.instantiate()
# 			inventory_slot_grid.add_child(new_slot)
# 			new_slot.set_current_item(item)
# 			inventory_items.append(item)
