class_name ItemData
extends Resource


@export var name: String
@export var type: LootEnums.ItemType
@export var icon: Texture2D

@export var min_ilvl: int = 1
@export var level_requirement: int = 1

@export var base_stats: Array[AffixData] = []
@export var implicit_modifiers: Array[AffixData] = []
@export var skill_data: SkillData = null # optional just if the item is a skill item

#@export var damages: Array[DamageSource]