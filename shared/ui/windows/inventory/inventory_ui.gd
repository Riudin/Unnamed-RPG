class_name InventoryUI
extends Control


@export var slot_scene: PackedScene

@onready var inventory_slot_grid: GridContainer = %InventorySlotGrid

var inventory_size: int = 6
var inventory_items: Array[ItemInstance] = []


func _ready() -> void:
	visible = false

	InventoryManager.items_changed.connect(_on_items_changed)


func _on_items_changed(new_items: Array[ItemInstance]):
	if new_items.size() > inventory_size:
			print("Inventory full!")
			return
	
	# Adding Items to Inventory Slot Grid
	for item in new_items:
		# No need to change Items that are already there
		if inventory_items.has(item):
			continue
		# Add new slot containing new item
		else:
			var new_slot: InventorySlot = slot_scene.instantiate()
			inventory_slot_grid.add_child(new_slot)
			new_slot.set_current_item(item)
			inventory_items.append(item)