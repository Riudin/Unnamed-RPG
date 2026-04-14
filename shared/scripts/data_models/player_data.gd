class_name PlayerData
extends Resource


# Identity & Progression
@export var character_name: String = "Hero"
@export var level: int = 1
@export var current_xp: int = 0
@export var skill_points: int = 0
@export var skill_points_spent: int = 0 # not yet possible

# Attributes
@export var base_attributes: AttributeData
@export var base_stats: StatBlock

# Skills
@export var equipped_skills: Array[SkillData]

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