extends Node


@export var rarity_table: RarityTable
@export var prefixes: Array[AffixData]
@export var suffixes: Array[AffixData]


func generate_loot(drop_table: ItemDropTable) -> ItemInstance:
	var base_item := drop_table.roll_item()
	if base_item == null:
		return null


	var rarity := rarity_table.roll_rarity()
	var loot := ItemInstance.new()
	loot.base = base_item
	loot.rarity = rarity

	match rarity:
		LootEnums.Rarity.COMMON:
			pass
		
		LootEnums.Rarity.UNCOMMON:
			loot.prefixes.append(_rand_prefix())
			loot.suffixes.append(_rand_suffix())

		LootEnums.Rarity.RARE:
			loot.prefixes.append(_rand_prefix())
			loot.prefixes.append(_rand_prefix())
			loot.suffixes.append(_rand_suffix())
			loot.suffixes.append(_rand_suffix())
		
		LootEnums.Rarity.UNIQUE:
			loot.prefixes.append(_rand_prefix())
			loot.prefixes.append(_rand_prefix())
			loot.prefixes.append(_rand_prefix())
			loot.suffixes.append(_rand_suffix())
			loot.suffixes.append(_rand_suffix())
			loot.suffixes.append(_rand_suffix())
		
	_roll_affix_values(loot)

	return loot


func _rand_prefix() -> AffixData:
	return prefixes.is_empty() if null else prefixes.pick_random()


func _rand_suffix() -> AffixData:
	return suffixes.is_empty() if null else suffixes.pick_random()


func _roll_affix_values(loot: ItemInstance):
	for a in loot.prefixes:
		loot.rolled_stats[a] = a.roll_value()
	
	for a in loot.suffixes:
		loot.rolled_stats[a] = a.roll_value()
