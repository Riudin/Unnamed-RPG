extends Node


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
	# Auto-load affixes from folders if not manually set
	if prefixes.is_empty():
		prefixes = _load_affixes_from_folder(prefix_folder_path)
	if suffixes.is_empty():
		suffixes = _load_affixes_from_folder(suffix_folder_path)


func generate_loot(drop_table: ItemDropTable) -> ItemInstance:
	# Generate Item Base
	var base_item := drop_table.roll_item()
	if base_item == null:
		return null

	# Generate Item Rarity
	var rarity := rarity_table.roll_rarity()
	var loot := ItemInstance.new()
	loot.base = base_item
	loot.rarity = rarity

	# If its a skill, pass skill data to item instance
	if base_item.skill_data != null:
		loot.skill_data = base_item.skill_data
		loot.rarity = LootEnums.Rarity.COMMON # for now only common skills

	# Generate Affixes based on Rarity
	_generate_affixes(loot, loot.rarity)
	_roll_affix_values(loot)

	return loot


func _generate_affixes(item: ItemInstance, rarity):
	prefix_pool = prefixes.duplicate(true)
	suffix_pool = suffixes.duplicate(true)

	match rarity:
		LootEnums.Rarity.COMMON:
			pass
		
		LootEnums.Rarity.UNCOMMON:
			item.prefixes.append(_rand_prefix())
			item.suffixes.append(_rand_suffix())

		LootEnums.Rarity.RARE:
			item.prefixes.append(_rand_prefix())
			item.prefixes.append(_rand_prefix())
			item.suffixes.append(_rand_suffix())
			item.suffixes.append(_rand_suffix())
		
		LootEnums.Rarity.UNIQUE:
			item.prefixes.append(_rand_prefix())
			item.prefixes.append(_rand_prefix())
			item.prefixes.append(_rand_prefix())
			item.suffixes.append(_rand_suffix())
			item.suffixes.append(_rand_suffix())
			item.suffixes.append(_rand_suffix())


func _rand_prefix() -> AffixData:
	# Check if there are any prefixes left to assign
	if prefix_pool.is_empty():
		return null
	
	var new_prefix = prefix_pool.pick_random()
	prefix_pool.erase(new_prefix)

	return new_prefix.duplicate(true)
	
	#return prefixes.is_empty() if null else prefixes.pick_random()


func _rand_suffix() -> AffixData:
	# Check if there are any prefixes left to assign
	if suffix_pool.is_empty():
		return null
	
	var new_suffix = suffix_pool.pick_random()
	suffix_pool.erase(new_suffix)

	return new_suffix.duplicate(true)

	#return suffixes.is_empty() if null else suffixes.pick_random()


func _roll_affix_values(loot: ItemInstance):
	for a in loot.prefixes:
		if a == null:
			continue

		for mod in a.mods:
			a.roll_value(mod)

	for a in loot.suffixes:
		if a == null:
			continue

		for mod in a.mods:
			a.roll_value(mod)


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

	_generate_affixes(item, item.rarity)
	_roll_affix_values(item)
