extends Node


var rng := RandomNumberGenerator.new()

@export var rarity_table: RarityTable
@export var default_drop_table: ItemDropTable

# These are duplicates of prefixes and suffixes that are specific to the generated item. We pick from here and delete picked affixes
var prefix_pool: Array[AffixData]
var suffix_pool: Array[AffixData]


func _ready() -> void:
	rng.randomize()


func generate_loot(enemy: EnemyData) -> Array[ItemInstance]:
	var loot_items: Array[ItemInstance] = []
	var default_drops: int = _calculate_drop_count(enemy.base_drop_slots, enemy.base_drop_chance, rng)
	var special_drops: int = _calculate_drop_count(enemy.special_drop_slots, enemy.special_drop_chance, rng)

	for i in range(default_drops):
		# Generate Item Base
		var base_item: ItemData = default_drop_table.roll_item(rng)
		assert(base_item, "LootGenerator: couldn't generate base item")

		# Generate Item Rarity
		var rarity := rarity_table.roll_rarity(rng)
		var loot := ItemInstance.new()
		loot.base = _clone_item_data(base_item)
		loot.rarity = rarity

		# If its a skill, pass skill data to item instance
		if base_item.skill_data != null:
			loot.skill_data = base_item.skill_data
			loot.rarity = LootEnums.Rarity.COMMON # for now only common skills

		# Roll fixed affixes
		_roll_base_values(loot, rng)
		_roll_implicit_values(loot, rng)

		# Generate Affixes based on Rarity
		_generate_affixes(loot, loot.rarity, rng)
		_roll_affix_tiers(loot, rng) # TODO: we need to get the monster level here to determine which tiers are possible
		_roll_affix_values(loot, rng)

		loot_items.append(loot)
	
	for i in range(special_drops):
		# Generate Item Base
		var base_item: ItemData = enemy.special_drop_table.roll_item(rng)
		assert(base_item, "LootGenerator: couldn't generate base item")

		# Generate Item Rarity
		var rarity := rarity_table.roll_rarity(rng)
		var loot := ItemInstance.new()
		loot.base = _clone_item_data(base_item)
		loot.rarity = rarity

		# If its a skill, pass skill data to item instance
		if base_item.skill_data != null:
			loot.skill_data = base_item.skill_data
			loot.rarity = LootEnums.Rarity.COMMON # for now only common skills

		# Roll fixed affixes
		_roll_base_values(loot, rng)
		_roll_implicit_values(loot, rng)

		# Generate Affixes based on Rarity
		_generate_affixes(loot, loot.rarity, rng)
		_roll_affix_tiers(loot, rng) # TODO: we need to get the monster level here to determine which tiers are possible
		_roll_affix_values(loot, rng)

		loot_items.append(loot)

	return loot_items


func _calculate_drop_count(slots: int, base_chance: float, rng: RandomNumberGenerator) -> int:
	var total_drops: int = 0
	var increased_item_quantity: float = GameState.player_data.stats.current_item_quantity / 100.0
	
	var slot_drop_chance: float = base_chance * (1.0 + increased_item_quantity)

	for i in range(slots):
		var guaranteed_drops: int = int(slot_drop_chance) # e.g. 250% chance returns 2.5 -> 2
		total_drops += guaranteed_drops

		var remainder_roll_chance: float = fmod(slot_drop_chance, 1.0) # returns only the remainder of the chance. e.g. 250% == 2.5 -> 0.5
		if rng.randf_range(0.1, 1.0) <= remainder_roll_chance:
			total_drops += 1

	return total_drops


# Item Data cloning is a fix because otherwise we would modify resources in the items that are shared and get similar values for different items
func _clone_item_data(item: ItemData) -> ItemData:
	if item == null:
		return null

	var cloned := item.duplicate(true)
	cloned.base_stats = _clone_affix_array(cloned.base_stats)
	cloned.implicit_modifiers = _clone_affix_array(cloned.implicit_modifiers)
	return cloned


func _clone_affix_array(affixes: Array[AffixData]) -> Array[AffixData]:
	var cloned: Array[AffixData] = []

	for affix in affixes:
		if affix == null:
			cloned.append(null)
			continue

		var affix_copy := affix.duplicate(true)
		for i in range(affix_copy.mods.size()):
			if affix_copy.mods[i] == null:
				continue
			affix_copy.mods[i] = affix_copy.mods[i].duplicate(true)

		cloned.append(affix_copy)

	return cloned


func _generate_affixes(item: ItemInstance, rarity, rng: RandomNumberGenerator):
	var valid_affixes := AffixManager.get_valid_affixes(item.base.tags)

	prefix_pool = valid_affixes.filter(func(a): return a.is_prefix)
	suffix_pool = valid_affixes.filter(func(a): return not a.is_prefix) # Note: before the last change this diplicated the prefixes/suffixes arrays. in case of bugs look here

	var affix_amount := 0
	var max_prefixes := 0
	var max_suffixes := 0
	match rarity:
		LootEnums.Rarity.COMMON:
			affix_amount = 0

		LootEnums.Rarity.UNCOMMON:
			affix_amount = rng.randi_range(1, 2)
			max_prefixes = 1
			max_suffixes = 1

		LootEnums.Rarity.RARE:
			affix_amount = rng.randi_range(2, 6)
			max_prefixes = 3
			max_suffixes = 3

		LootEnums.Rarity.UNIQUE:
			affix_amount = 0 # TODO: implement unique logic
	
	var prefix_count := 0
	var suffix_count := 0
	for a in range(affix_amount):
		if rng.randf() < 0.5:
			if prefix_count < max_prefixes:
				item.prefixes.append(_rand_prefix(rng))
				prefix_count += 1
			elif suffix_count < max_suffixes:
				item.suffixes.append(_rand_suffix(rng))
				suffix_count += 1
		else:
			if suffix_count < max_suffixes:
				item.suffixes.append(_rand_suffix(rng))
				suffix_count += 1
			elif prefix_count < max_prefixes:
				item.prefixes.append(_rand_prefix(rng))
				prefix_count += 1

	# match rarity:
	# 	LootEnums.Rarity.COMMON:
	# 		pass
		
	# 	LootEnums.Rarity.UNCOMMON:
	# 		item.prefixes.append(_rand_prefix(rng))
	# 		item.suffixes.append(_rand_suffix(rng))

	# 	LootEnums.Rarity.RARE:
	# 		item.prefixes.append(_rand_prefix(rng))
	# 		item.prefixes.append(_rand_prefix(rng))
	# 		item.suffixes.append(_rand_suffix(rng))
	# 		item.suffixes.append(_rand_suffix(rng))
		
	# 	LootEnums.Rarity.UNIQUE:
	# 		item.prefixes.append(_rand_prefix(rng))
	# 		item.prefixes.append(_rand_prefix(rng))
	# 		item.prefixes.append(_rand_prefix(rng))
	# 		item.suffixes.append(_rand_suffix(rng))
	# 		item.suffixes.append(_rand_suffix(rng))
	# 		item.suffixes.append(_rand_suffix(rng))


func _rand_prefix(rng: RandomNumberGenerator) -> AffixData:
	# Check if there are any prefixes left to assign
	if prefix_pool.is_empty():
		return null
	
	var index := rng.randi_range(0, prefix_pool.size() - 1)
	var new_prefix = prefix_pool[index]
	prefix_pool.erase(new_prefix)

	return new_prefix.duplicate(true)
	

func _rand_suffix(rng: RandomNumberGenerator) -> AffixData:
	# Check if there are any prefixes left to assign
	if suffix_pool.is_empty():
		return null
	
	var index := rng.randi_range(0, suffix_pool.size() - 1)
	var new_suffix = suffix_pool[index]
	suffix_pool.erase(new_suffix)

	return new_suffix.duplicate(true)


func _roll_affix_tiers(item: ItemInstance, rng: RandomNumberGenerator) -> void:
	for a in item.prefixes:
		if a == null:
			continue

		a.tier = rng.randi_range(a.min_tier, a.max_tier) # this means all tiers are equally as likely
		a.assign_values_to_mods()

	for a in item.suffixes:
		if a == null:
			continue

		a.tier = rng.randi_range(a.min_tier, a.max_tier) # this means all tiers are equally as likely
		a.assign_values_to_mods()


func _roll_affix_values(loot: ItemInstance, rng: RandomNumberGenerator):
	for a in loot.prefixes:
		if a == null:
			continue

		for mod in a.mods:
			a.roll_value(mod, rng)

	for a in loot.suffixes:
		if a == null:
			continue

		for mod in a.mods:
			a.roll_value(mod, rng)


func _roll_base_values(loot: ItemInstance, rng: RandomNumberGenerator) -> void:
	for a in loot.base.base_stats:
			if a == null:
				continue
			
			for mod in a.mods:
				a.roll_value(mod, rng)


func _roll_implicit_values(loot: ItemInstance, rng: RandomNumberGenerator) -> void:
	for a in loot.base.implicit_modifiers:
		if a == null:
			continue
		
		for mod in a.mods:
			a.roll_value(mod, rng)


# Crafting Methods
func reroll_affixes(item: ItemInstance):
	item.prefixes.clear()
	item.suffixes.clear()

	_generate_affixes(item, item.rarity, rng)
	_roll_affix_tiers(item, rng) # TODO: we need to get the monster level here to determine which tiers are possible
	_roll_affix_values(item, rng)
