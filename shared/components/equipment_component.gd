class_name EquipmentComponent
extends Node


@onready var parent := get_parent()


var slots := {
	LootEnums.ItemType.WEAPON: null,
	LootEnums.ItemType.OFFHAND: null,
	LootEnums.ItemType.ARMOR: null,
	LootEnums.ItemType.HELMET: null,
	LootEnums.ItemType.GLOVES: null,
	LootEnums.ItemType.BOOTS: null,
	LootEnums.ItemType.BELT: null,
	LootEnums.ItemType.RING1: null,
	LootEnums.ItemType.RING2: null,
	LootEnums.ItemType.AMULET: null,
	LootEnums.ItemType.PET: null
}


func equip(item: ItemInstance):
	var slot = item.base.type
	var old = slots[slot]
	slots[slot] = item

	if slot == LootEnums.ItemType.WEAPON:
		parent.attack_component.set_damages(item.get_damages())

	return old


func unequip(slot):
	var old = slots[slot]
	slots[slot] = null
	return old


func get_item(slot):
	return slots[slot]


func get_all_items():
	return slots.values()