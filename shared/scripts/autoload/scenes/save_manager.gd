extends Node
# FYI: The Save Game Manager is built in a way that would also support items that take up 
# more than one inventory space, in case we want that later


const SAVE_FOLDER := "user://saves/"
const SLOT_COUNT: int = 3

signal game_loaded


func _ready() -> void:
	if !DirAccess.dir_exists_absolute(SAVE_FOLDER):
		DirAccess.make_dir_absolute(SAVE_FOLDER)


func _save_player(player):
	return {
		"position": player.global_position,
		"health": player.health_component.health
	}


func _load_player(player, data):
	player.global_position = data.position
	player.health_component.health = data.health


func _save_level(player):
	return {
		"level": player.leveling_component.level,
		"current_xp": player.leveling_component.current_xp,
		"skill_points": player.leveling_component.skill_points
	}


func _load_level(player, data):
	player.leveling_component.level = data.level
	player.leveling_component.current_xp = data.current_xp
	player.leveling_component.skill_points = data.skill_points


func _get_item_position(item):
	for pos in InventoryManager.grid.keys():
		if InventoryManager.grid[pos] == item:
			return pos
	
	return Vector2i.ZERO


func _build_item(data):
	var item := ItemInstance.new()

	item.base = load(data.base)
	item.rarity = data.rarity

	for p in data.prefixes:
		item.prefixes.append(load(p))

	for s in data.suffixes:
		item.suffixes.append(load(s))

	item.rolled_stats = data.stats

	return item


func _affix_paths(list):
	var paths: Array = []

	for a in list:
		paths.append(a.resource_path)

	return paths


func _save_inventory():
	var items := []
	var saved := []

	for item in InventoryManager.grid.values():
		if saved.has(item):
			continue
	
		saved.append(item)

		items.append({
			"base": item.base.resource_path,
			"rarity": item.rarity,
			"prefixes": _affix_paths(item.prefixes),
			"suffixes": _affix_paths(item.suffixes),
			"stats": item.rolled_stats,
			"pos": _get_item_position(item)
		})

	return items


func _load_inventory(data):
	InventoryManager.grid.clear()

	for c in InventoryManager.inventory_ui.get_children():
		if c is ItemUI:
			c.queue_free()

	for item_data in data:
		var item = _build_item(item_data)
		InventoryManager.place(item, item_data.pos)
		InventoryManager.inventory_ui.spawn_item_ui(item, item_data.pos)


func _save_equipment(player):
	var result := {}

	for slot in player.equipment_component.slots.keys():
		var item = player.equipment_component.slots[slot]

		if item == null:
			continue
		
		result[slot] = {
			"base": item.base.resource_path,
			"rarity": item.rarity,
			"prefixes": _affix_paths(item.prefixes),
			"suffixes": _affix_paths(item.suffixes),
			"stats": item.rolled_stats
		}
	
	return result


func _load_equipment(player, data):
	var equip = player.equipment_component

	for slot in equip.slots.keys():
		equip.slots[slot] = null
	
	for slot in data.keys():
		var item = _build_item(data[slot])
		equip.slots[int(slot)] = item


func get_slot_path(slot: int) -> String:
	return SAVE_FOLDER + "slot_%d.save" % slot


func get_slot_time(slot: int):
	var path = get_slot_path(slot)

	if !FileAccess.file_exists(path):
		return null
	
	var file = FileAccess.open(path, FileAccess.READ)
	var data = file.get_var()

	return data.timestamp


func save_game(slot: int, player):
	var save_data := {}

	save_data.player = _save_player(player)
	save_data.attribute_data = player.attribute_data.to_dict()
	save_data.level = _save_level(player)
	#save_data.gold = player.gold
	save_data.inventory = _save_inventory()
	save_data.equipment = _save_equipment(player)
	save_data.timestamp = Time.get_datetime_dict_from_system()

	var file = FileAccess.open(get_slot_path(slot), FileAccess.WRITE)
	file.store_var(save_data)

	print("Game Saved in Slot: ", slot)


func load_game(slot: int, player) -> bool:
	var path = get_slot_path(slot)

	if !FileAccess.file_exists(path):
		print("Save does not exist!")
		return false
	
	var file = FileAccess.open(path, FileAccess.READ)
	var data = file.get_var()

	_load_player(player, data.player)
	player.attribute_data.from_dict(data.attribute_data)
	_load_level(player, data.level)
	#player.gold = data.gold
	_load_inventory(data.inventory)
	_load_equipment(player, data.equipment)
	player.recalculate_stats()

	print("Game Loaded from Slot: ", slot)

	game_loaded.emit()

	return true
