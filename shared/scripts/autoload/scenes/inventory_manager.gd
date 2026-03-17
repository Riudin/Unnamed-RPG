extends Node


const GRID_SIZE := Vector2i(9, 12)

var grid := {} # Vector2i -> ItemInstance
var inventory_ui: InventoryUI


func register_ui(ui: InventoryUI):
	inventory_ui = ui


func can_place(_item: ItemInstance, pos: Vector2i) -> bool:
	if grid.has(pos):
		return false
	return true


func place(item: ItemInstance, pos: Vector2i):
	grid[pos] = item


func clear_item(item: ItemInstance):
	for k in grid.keys():
		if grid[k] == item:
			grid.erase(k)


func add_item(item: ItemInstance) -> bool:
	for y in GRID_SIZE.y:
		for x in GRID_SIZE.x:
			var pos := Vector2i(x, y)
			if can_place(item, pos):
				place(item, pos)
				inventory_ui.spawn_item_ui(item, pos)
				return true
	return false