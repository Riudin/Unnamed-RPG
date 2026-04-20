class_name EquipmentComponent
extends Node


@onready var parent := get_parent()

var player_data: PlayerData = null


var slots: Dictionary[int, ItemInstance] = { # we need this here to match item type to slot before passing the result to playerdata
	LootEnums.ItemType.WEAPON: null,
	LootEnums.ItemType.OFFHAND: null,
	LootEnums.ItemType.ARMOR: null,
	LootEnums.ItemType.HELMET: null,
	LootEnums.ItemType.GLOVES: null,
	LootEnums.ItemType.BOOTS: null,
	LootEnums.ItemType.BELT: null,
	LootEnums.ItemType.AMULET: null,
	LootEnums.ItemType.WINGS: null,
	LootEnums.ItemType.PET: null
}

# Multi-slot items tracked by position
#var skill_slots: Array[ItemInstance] = [null, null, null, null, null] # 5 skill slots
#var ring_slots: Array[ItemInstance] = [null, null] # 2 ring slots


func _ready() -> void:
	player_data = GameState.player_data # this is a dependency on GameState. We could instead set player_data via the player script or in the editor

	load_from_player_data()


func equip(item: ItemInstance, slot_index: int = 0) -> ItemInstance:
	match item.base.type:
		LootEnums.ItemType.SKILL:
			if slot_index >= player_data.skill_slots.size():
				push_error("Skill slot index out of range: %d" % slot_index)
				return null
			var old = player_data.skill_slots[slot_index]
			player_data.skill_slots[slot_index] = item
			return old
		
		LootEnums.ItemType.RING:
			if slot_index >= player_data.ring_slots.size():
				push_error("Ring slot index out of range: %d" % slot_index)
				return null
			var old = player_data.ring_slots[slot_index]
			player_data.ring_slots[slot_index] = item
			return old
		
		_: # Single-slot items
			var slot = item.base.type
			var old = slots[slot]
			slots[slot] = item
			
			player_data.equipment_slots = slots

			# if slot == LootEnums.ItemType.WEAPON:
			# 	parent.attack_component.set_damages(item.get_damages())
			
			return old


func unequip(slot: LootEnums.ItemType, slot_index: int = 0) -> ItemInstance:
	match slot:
		LootEnums.ItemType.SKILL:
			if slot_index >= player_data.skill_slots.size():
				push_error("Skill slot index out of range: %d" % slot_index)
				return null
			var old = player_data.skill_slots[slot_index]
			player_data.skill_slots[slot_index] = null
			return old
		
		LootEnums.ItemType.RING:
			if slot_index >= player_data.ring_slots.size():
				push_error("Ring slot index out of range: %d" % slot_index)
				return null
			var old = player_data.ring_slots[slot_index]
			player_data.ring_slots[slot_index] = null
			return old
		
		_: # Single-slot items
			var old = slots[slot]
			slots[slot] = null
			
			player_data.equipment_slots = slots

			# if slot == LootEnums.ItemType.WEAPON:
			# 	parent.attack_component.set_damages(null)
			
			return old


func get_item(item_type: LootEnums.ItemType, slot_index: int = 0) -> ItemInstance:
	match item_type:
		LootEnums.ItemType.SKILL:
			return player_data.skill_slots[slot_index] if slot_index < player_data.skill_slots.size() else null
		LootEnums.ItemType.RING:
			return player_data.ring_slots[slot_index] if slot_index < player_data.ring_slots.size() else null
		_:
			return slots[item_type]


func get_all_items():
	return slots.values()


func get_all_skills() -> Array[SkillData]:
	var skill_data_array: Array[SkillData] = []
	for item in player_data.skill_slots:
		if item == null:
			skill_data_array.append(null)
		else:
			skill_data_array.append(item.skill_data)
	return skill_data_array


func get_all_rings() -> Array[ItemInstance]:
	return player_data.ring_slots


func load_from_player_data():
	slots = player_data.equipment_slots
