class_name ItemData
extends Resource


@export var name: String
@export var type: LootEnums.ItemType
@export var icon: Texture2D

@export var skill_data: SkillData = null # optional just if the item is a skill item

#@export var damages: Array[DamageSource]