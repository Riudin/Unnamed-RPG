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
	LootEnums.ItemType.AMULET: null,
	LootEnums.ItemType.WINGS: null,
	LootEnums.ItemType.PET: null,
}

# Multi-slot items tracked by position
var skill_slots: Array[ItemInstance] = [null, null, null, null, null] # 5 skill slots
var ring_slots: Array[ItemInstance] = [null, null] # 2 ring slots


func equip(item: ItemInstance, slot_index: int = 0) -> ItemInstance:
	match item.base.type:
		LootEnums.ItemType.SKILL:
			if slot_index >= skill_slots.size():
				push_error("Skill slot index out of range: %d" % slot_index)
				return null
			var old = skill_slots[slot_index]
			skill_slots[slot_index] = item
			return old
		
		LootEnums.ItemType.RING:
			if slot_index >= ring_slots.size():
				push_error("Ring slot index out of range: %d" % slot_index)
				return null
			var old = ring_slots[slot_index]
			ring_slots[slot_index] = item
			return old
		
		_: # Single-slot items
			var slot = item.base.type
			var old = slots[slot]
			slots[slot] = item
			
			if slot == LootEnums.ItemType.WEAPON:
				parent.attack_component.set_damages(item.get_damages())
			
			return old


func unequip(slot: LootEnums.ItemType, slot_index: int = 0) -> ItemInstance:
	match slot:
		LootEnums.ItemType.SKILL:
			if slot_index >= skill_slots.size():
				push_error("Skill slot index out of range: %d" % slot_index)
				return null
			var old = skill_slots[slot_index]
			skill_slots[slot_index] = null
			return old
		
		LootEnums.ItemType.RING:
			if slot_index >= ring_slots.size():
				push_error("Ring slot index out of range: %d" % slot_index)
				return null
			var old = ring_slots[slot_index]
			ring_slots[slot_index] = null
			return old
		
		_: # Single-slot items
			var old = slots[slot]
			slots[slot] = null
			
			if slot == LootEnums.ItemType.WEAPON:
				parent.attack_component.set_damages(null)
			
			return old


func get_item(item_type: LootEnums.ItemType, slot_index: int = 0) -> ItemInstance:
	match item_type:
		LootEnums.ItemType.SKILL:
			return skill_slots[slot_index] if slot_index < skill_slots.size() else null
		LootEnums.ItemType.RING:
			return ring_slots[slot_index] if slot_index < ring_slots.size() else null
		_:
			return slots[item_type]


func get_all_items():
	return slots.values()


func get_all_skills() -> Array[SkillData]:
	var skill_data_array: Array[SkillData] = []
	for item in skill_slots:
		if item == null:
			skill_data_array.append(null)
		else:
			skill_data_array.append(item.skill_data)
	return skill_data_array


func get_all_rings() -> Array[ItemInstance]:
	return ring_slots
