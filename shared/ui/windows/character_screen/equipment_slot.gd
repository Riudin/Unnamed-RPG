class_name EquipmentSlot
extends Control


@onready var item_icon: TextureRect = $ItemIcon

@export var slot_type: LootEnums.ItemType
@export var player: Player

static var hovered_slot: EquipmentSlot = null

var equipped_item: ItemInstance


func _update_icon():
	if equipped_item:
		item_icon.texture = equipped_item.base.icon
	else:
		item_icon.texture = null


func drop_item(item: ItemInstance) -> bool:
	if item.base.type != slot_type:
		return false

	var old := equipped_item

	equipped_item = item
	_update_icon()

	player.equipment_component.equip(item)
	player.recalculate_stats()

	if old:
		InventoryManager.add_item(old)
	
	return true


func _on_mouse_entered() -> void:
	hovered_slot = self


func _on_mouse_exited() -> void:
	if hovered_slot == self:
		hovered_slot = null
