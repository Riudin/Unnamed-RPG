class_name ItemData
extends Resource


@export_category("Base Data")
@export var name: String
@export var type: LootEnums.ItemType
@export var icon: Texture2D

enum Tags {
	MIGHT = 1,
	GRACE = 2,
	WILL = 4,
	ARMOR = 8,
	JEWELERY = 16,
	WEAPON = 32,
	SKILL = 64
	}
	# WARNING: Only add new tags to the back of the list (20/32)
# the export flags must match the Tags enum on spelling and order
@export_group("Tags")
@export_flags("Might", "Grace", "Will", "Armor", "Jewelery", "Weapon", "Skill")
var tags: int = 0


@export_category("Requirements")
@export var min_ilvl: int = 1
@export var level_requirement: int = 1

@export_category("Data")
@export var base_stats: Array[AffixData] = []
@export var implicit_modifiers: Array[AffixData] = []
@export var skill_data: SkillData = null # optional just if the item is a skill item