extends Node


var inventory_items: Array[ItemInstance] = []

signal items_changed(new_items)


func add_item(item: ItemInstance):
	inventory_items.append(item)
	items_changed.emit(inventory_items)


func remove_item(item: ItemInstance):
	inventory_items.erase(item)
	items_changed.emit(inventory_items)
