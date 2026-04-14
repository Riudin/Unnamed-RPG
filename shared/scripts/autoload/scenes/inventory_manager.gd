extends Node


const GRID_SIZE := Vector2i(9, 12)

var grid: Dictionary[Vector2i, ItemInstance] = {}
var inventory_ui: InventoryUI


func _ready() -> void:
	# Load state from saved playerdata
	if GameState.player_data.inventory_grid:
		grid = GameState.player_data.inventory_grid


func register_ui(ui: InventoryUI):
	inventory_ui = ui


func can_place(_item: ItemInstance, pos: Vector2i) -> bool:
	if grid.has(pos):
		return false
	return true


func place(item: ItemInstance, pos: Vector2i):
	grid[pos] = item
	update_player_data()


func clear_item(item: ItemInstance):
	for k in grid.keys():
		if grid[k] == item:
			grid.erase(k)
			update_player_data()


func add_item(item: ItemInstance) -> bool:
	for y in GRID_SIZE.y:
		for x in GRID_SIZE.x:
			var pos := Vector2i(x, y)
			if can_place(item, pos):
				place(item, pos)
				inventory_ui.spawn_item_ui(item, pos)
				#update_player_data()
				return true
	return false


# Helper function to keep GameState up to date. GameState holds a duplicate of grid for saving purposes
func update_player_data():
	if GameState.player_data:
		GameState.player_data.inventory_grid = grid
