class_name InventorySlot
extends Control


@onready var item_icon_display: TextureRect = %ItemIconDisplay
@onready var item_name_display: Label = %ItemNameDisplay

var current_item: ItemInstance = null: set = set_current_item


func set_current_item(item):
	current_item = item
	if item.base.icon: item_icon_display.texture = item.base.icon
	item_name_display.text = item.get_display_name()


func _on_background_mouse_entered() -> void:
	SignalBus.inventory_slot_mouse_entered.emit(self )


func _on_background_mouse_exited() -> void:
	SignalBus.inventory_slot_mouse_exited.emit(self )
