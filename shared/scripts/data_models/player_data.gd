class_name PlayerData
extends Resource


signal stats_changed


# Identity & Progression
@export var character_name: String = "Player"
@export var skill_points: int = 0
@export var skill_points_spent: int = 0 # not yet possible

@export var stats: Stats:
	set(new_value):
		stats = new_value
		stats_changed.emit()

# Skills
@export var equipped_skills: Array[SkillData]
@export var active_skill: SkillData = null:
	set(new_value):
		if active_skill and not active_skill.inherent_mods.is_empty():
			for mod in active_skill.inherent_mods:
				stats.remove_modifier(mod)
		active_skill = new_value
		if active_skill and not active_skill.inherent_mods.is_empty():
			for mod in active_skill.inherent_mods:
				stats.add_modifier(mod)
		
		stats_changed.emit()

# Equipment - Single slot items
@export var equipment_slots: Dictionary[int, ItemInstance] = {
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

# Equipment - Multi-slot items
@export var skill_slots: Array[ItemInstance] = [null, null, null, null, null] # 5 skill slots
@export var ring_slots: Array[ItemInstance] = [null, null] # 2 ring slots

# Inventory
@export var inventory_grid: Dictionary[Vector2i, ItemInstance] = {}