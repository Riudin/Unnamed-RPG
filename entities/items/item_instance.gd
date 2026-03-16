class_name ItemInstance
extends Resource


@export var base: ItemData
@export var rarity: LootEnums.Rarity

@export var prefixes: Array[AffixData] = []
@export var suffixes: Array[AffixData] = []

var rolled_stats: Dictionary = {} # stat_name: rolled_value

const RARITY_COLORS := {
	LootEnums.Rarity.COMMON: Color.WHITE,
	LootEnums.Rarity.UNCOMMON: Color("00e11cff"),
	LootEnums.Rarity.RARE: Color("2a1fd7ff"),
	LootEnums.Rarity.UNIQUE: Color("#ff6a00")
}


func get_display_name() -> String:
	var n = base.name

	if rarity == LootEnums.Rarity.UNCOMMON:
		for p in prefixes:
			n = p.name_format % n

		for s in suffixes:
			n = s.name_format % n
	elif rarity == LootEnums.Rarity.RARE:
		n = "Rare " + n
	elif rarity == LootEnums.Rarity.UNIQUE:
		n = "Unique Item Placeholder Name"

	return n


func get_color() -> Color:
	return RARITY_COLORS[rarity]
