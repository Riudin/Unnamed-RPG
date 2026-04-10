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
@export var equipment_slots: Dictionary[int, ItemInstance] = {}

# Equipment - Multi-slot items
@export var skill_slots: Array[ItemInstance] = [null, null, null, null, null] # 5 skill slots
@export var ring_slots: Array[ItemInstance] = [null, null] # 2 ring slots

# Inventory
@export var inventory: Dictionary[Vector2i, ItemInstance] = {}
