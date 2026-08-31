class_name AffixRule
extends Resource


@export var rule_name: String = ""

## This rule only governs affixes carrying ANY of these tags
@export_flags("Attribute", "Defenses", "Life", "Damage", "Physical", "Cold", "Fire",
			"Lightning", "Chaos", "Life Regen", "Elemental", "Skill", "Mana", "Aegis",
			"Attack", "Spell", "Critical", "Aura", "Minion", "Status Effect", "Resistance")
var affix_tags_governed: int = 0

## Item must have ALL of these tags for governed affixes to be allowed (0 = ignore)
@export_flags("Might", "Grace", "Will", "Armor", "Jewelery", "Weapon", "Skill")
var item_required_tags: int = 0

## Item must have ANY of these tags for governed affixes to be allowed (0 = ignore)
@export_flags("Might", "Grace", "Will", "Armor", "Jewelery", "Weapon", "Skill")
var item_any_tags: int = 0

## Item cannot have ANY of these tags for governed affixes to be allowed (0 = ignore)
@export_flags("Might", "Grace", "Will", "Armor", "Jewelery", "Weapon", "Skill")
var item_excluded_tags: int = 0