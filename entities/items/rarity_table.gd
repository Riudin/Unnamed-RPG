class_name RarityTable
extends Resource


@export var rarity_weights: Dictionary[LootEnums.Rarity, int] = {
	LootEnums.Rarity.COMMON: 70,
	LootEnums.Rarity.UNCOMMON: 25,
	LootEnums.Rarity.RARE: 4,
	LootEnums.Rarity.UNIQUE: 1
}


func roll_rarity() -> LootEnums.Rarity:
	var total := 0
	for w in rarity_weights.values():
		total += w
	
	var roll := randi_range(1, total)
	var sum := 0

	for r in rarity_weights.keys():
		sum += rarity_weights[r]
		if roll <= sum:
			return r
	
	# return common as default if something goes wrong
	return LootEnums.Rarity.COMMON