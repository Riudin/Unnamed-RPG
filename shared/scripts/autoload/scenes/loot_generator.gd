extends Node


var rng := RandomNumberGenerator.new()

@export var rarity_table: RarityTable
var prefixes: Array[AffixData]
var suffixes: Array[AffixData]

# Folder paths for automatic loading
@export var prefix_folder_path: String = "res://entities/items/affixes/prefixes"
@export var suffix_folder_path: String = "res://entities/items/affixes/suffixes"

# These are duplicates of prefixes and suffixes that are specific to the generated item. We pick from here and delete picked affixes
var prefix_pool: Array[AffixData]
var suffix_pool: Array[AffixData]


func _ready() -> void:
	rng.randomize()
	# Auto-load affixes from folders if not manually set
	if prefixes.is_empty():
		prefixes = _load_affixes_from_folder(prefix_folder_path)
	if suffixes.is_empty():
		suffixes = _load_affixes_from_folder(suffix_folder_path)


func generate_loot(drop_table: ItemDropTable) -> ItemInstance:
	# Generate Item Base
	var base_item := drop_table.roll_item(rng)
	if base_item == null:
		return null

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

	return loot


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
	prefix_pool = prefixes.duplicate(true)
	suffix_pool = suffixes.duplicate(true)

	match rarity:
		LootEnums.Rarity.COMMON:
			pass
		
		LootEnums.Rarity.UNCOMMON:
			item.prefixes.append(_rand_prefix(rng))
			item.suffixes.append(_rand_suffix(rng))

		LootEnums.Rarity.RARE:
			item.prefixes.append(_rand_prefix(rng))
			item.prefixes.append(_rand_prefix(rng))
			item.suffixes.append(_rand_suffix(rng))
			item.suffixes.append(_rand_suffix(rng))
		
		LootEnums.Rarity.UNIQUE:
			item.prefixes.append(_rand_prefix(rng))
			item.prefixes.append(_rand_prefix(rng))
			item.prefixes.append(_rand_prefix(rng))
			item.suffixes.append(_rand_suffix(rng))
			item.suffixes.append(_rand_suffix(rng))
			item.suffixes.append(_rand_suffix(rng))


func _rand_prefix(rng: RandomNumberGenerator) -> AffixData:
	# Check if there are any prefixes left to assign
	if prefix_pool.is_empty():
		return null
	
	var index := rng.randi_range(0, prefix_pool.size() - 1)
	var new_prefix = prefix_pool[index]
	prefix_pool.erase(new_prefix)

	return new_prefix.duplicate(true)
	
	#return prefixes.is_empty() if null else prefixes.pick_random()


func _rand_suffix(rng: RandomNumberGenerator) -> AffixData:
	# Check if there are any prefixes left to assign
	if suffix_pool.is_empty():
		return null
	
	var index := rng.randi_range(0, suffix_pool.size() - 1)
	var new_suffix = suffix_pool[index]
	suffix_pool.erase(new_suffix)

	return new_suffix.duplicate(true)

	#return suffixes.is_empty() if null else suffixes.pick_random()


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


func _load_affixes_from_folder(folder_path: String) -> Array[AffixData]:
	var affixes: Array[AffixData] = []
	
	var dir = DirAccess.open(folder_path)
	if dir == null:
		push_error("Failed to open folder: " + folder_path)
		return affixes
	
	dir.list_dir_begin()
	var file_name = dir.get_next()
	
	while file_name != "":
		# Only load .tres files, skip directories and other files
		if file_name.ends_with(".tres"):
			var resource_path = folder_path.path_join(file_name)
			var affix = load(resource_path) as AffixData
			
			if affix != null:
				affixes.append(affix)
			else:
				push_warning("Failed to load affix from: " + resource_path)
		
		file_name = dir.get_next()
	
	return affixes


# Crafting Methods
func reroll_affixes(item: ItemInstance):
	item.prefixes.clear()
	item.suffixes.clear()

	_generate_affixes(item, item.rarity, rng)
	_roll_affix_tiers(item, rng) # TODO: we need to get the monster level here to determine which tiers are possible
	_roll_affix_values(item, rng)
