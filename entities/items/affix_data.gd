class_name AffixData
extends Resource


@export_category("Base Data")
@export var is_prefix: bool = true

# We give each enum a value of 2^n in order to adress it bitwise. this means that each enum has a different bitmask and we can look them up via bitwise and / or operations
# Has Tag: "if affix.tags & AffixData.Tags.FIRE"
# Has ANY of Tags: "if affix.tags & (AffixData.Tags.DAMAGE | AffixData.Tags.FIRE)"
# Has ALL of Tags: "if (affix.tags & (AffixData.Tags.DAMAGE | AffixData.Tags.FIRE)) == (AffixData.Tags.DAMAGE | AffixData.Tags.FIRE)" -> useful to abstract here
# Has NONE of Tags: "if (affix.tags & (AffixData.Tags.DAMAGE | AffixData.Tags.FIRE)) == 0"
# IMPORTANT: @export_flags supports up to 32 bits, so we can at most have 32 tags. limit would be 2^31 = 2,147,483,648
enum Tags {ATTRIBUTE = 1,
		DEFENCES = 2,
		LIFE = 4,
		DAMAGE = 8,
		PHYSICAL = 16,
		COLD = 32,
		FIRE = 64,
		LIGHTNING = 128,
		CHAOS = 256,
		LIFE_REGEN = 512,
		ELEMENTAL = 1024,
		SKILL = 2048,
		MANA = 4096,
		AEGIS = 8192,
		ATTACK = 16384,
		SPELL = 32768,
		CRITICAL = 65536,
		AURA = 131072,
		MINION = 262144,
		STATUS_EFFECT = 524288,
		RESISTANCE = 1048576}
		# WARNING: Only add new tags to the back of the list (20/32)
# the export flags must match the Tags enum on spelling and order
@export_group("Tags")
@export_flags("Attribute",
		"Defenses",
		"Life",
		"Damage",
		"Physical",
		"Cold",
		"Fire",
		"Lightning",
		"Chaos",
		"Life Regen",
		"Elemental",
		"Skill",
		"Mana",
		"Aegis",
		"Attack",
		"Spell",
		"Critical",
		"Aura",
		"Minion",
		"Status Effect",
		"Resistance") var tags: int = 0

@export_group("Tag restrictions")
@export_flags("Might", "Grace", "Will", "Armor", "Jewelery", "Weapon", "Skill") # Keep matching ItemData Tags
var required_tags: int = 0
@export_flags("Might", "Grace", "Will", "Armor", "Jewelery", "Weapon", "Skill") # Keep matching ItemData Tags
var excluded_tags: int = 0


@export_category("Tier Values")
@export var min_tier: int = 1
@export var max_tier: int = 2
var tier: int = 1

@export var tier_values: Dictionary = {
	1: {
		"lvl_req": 1,
		"min": 1,
		"max": 3,
		"min_range": 4,
		"max_range": 6
		},
	2: {
		"lvl_req": 6,
		"min": 3,
		"max": 5,
		"min_range": 8,
		"max_range": 10
		}
}

@export_category("Behavior")
@export var mods: Array[StatModifier] = [] # this should atm only be one mod. some things like tier values are not prepared for multiple mods


func assign_values_to_mods() -> void:
	for mod in mods:
		if mod == null: continue

		mod.min_amount = tier_values[tier]["min"]
		mod.range_min_amount = tier_values[tier]["min_range"]
		mod.max_amount = tier_values[tier]["max"]
		mod.range_max_amount = tier_values[tier]["max_range"]


func roll_value(mod: StatModifier, rng: RandomNumberGenerator = null) -> void:
	mod.roll_amount(rng)


static func tags_to_string(mask: int) -> String:
	var names: Array[String] = []
	for key in Tags.keys():
		var value = Tags[key]
		if mask & value:
			names.append(key.capitalize())
	return ", ".join(names)