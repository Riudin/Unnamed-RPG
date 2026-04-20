class_name ItemInstance
extends Resource


@export var base: ItemData
@export var rarity: LootEnums.Rarity

@export var skill_data: SkillData = null

@export var prefixes: Array[AffixData] = []
@export var suffixes: Array[AffixData] = []

#var rolled_stats: Dictionary = {} # stat_name: rolled_value

const RARITY_COLORS := {
	LootEnums.Rarity.COMMON: Color.WHITE,
	LootEnums.Rarity.UNCOMMON: Color("547fe3"),
	LootEnums.Rarity.RARE: Color("cfb41f"),
	LootEnums.Rarity.UNIQUE: Color("bf6234")
}


func get_display_name() -> String:
	var n = base.name

	if rarity == LootEnums.Rarity.UNCOMMON:
		n = "Uncommon " + n
		# if not prefixes.is_empty():
		# 	for p in prefixes:
		# 		n = p.name_format % n

		# if not suffixes.is_empty():
		# 	for s in suffixes:
		# 		n = s.name_format % n
	elif rarity == LootEnums.Rarity.RARE:
		n = "Rare " + n
	elif rarity == LootEnums.Rarity.UNIQUE:
		n = "Unique Item Placeholder Name"

	return n


func get_color() -> Color:
	return RARITY_COLORS[rarity]


func get_damages() -> Array[DamageSource]:
	var result: Array[DamageSource] = []

	for d in base.damages:
		result.append(d.duplicate(true))
	
	for a in prefixes + suffixes:
		if a.damage:
			result.append(a.damage.duplicate(true))
	
	return result


# Crafting methods
func reroll_affixes():
	LootGenerator.reroll_affixes(self )
