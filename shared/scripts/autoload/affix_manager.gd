extends Node


# Folder paths for automatic loading
const AFFIX_DIR: String = "res://entities/items/affixes/"
const RULE_DIR: String = "res://entities/items/affix_rules"

var affixes: Array[AffixData] = []
var rules: Array[AffixRule] = []

var _cache: Dictionary = {} # item_tags (int): Array[AffixData]


func _ready() -> void:
	_load_affixes()
	_load_rules_from_folder()


func _load_affixes() -> void:
	affixes.clear()
	_load_affixes_recursive(AFFIX_DIR)


func _load_affixes_recursive(path: String) -> void:
	var dir := DirAccess.open(path)
	if dir == null:
		push_error("AffixManager: could not open %s" % path)
		return

	dir.list_dir_begin()
	var entry := dir.get_next()
	while entry != "":
		if entry == "." or entry == "..":
			entry = dir.get_next()
			continue

		var full_path := path.path_join(entry)
		if dir.current_is_dir():
			_load_affixes_recursive(full_path)
		elif entry.ends_with(".tres"):
			var res := load(full_path)
			if res is AffixData:
				affixes.append(res)

		entry = dir.get_next()


func _load_rules_from_folder() -> void:
	rules.clear()
	var dir := DirAccess.open(RULE_DIR)
	if dir == null:
		push_error("AffixManager: Failed to open folder: " + RULE_DIR)
		return
	for file_name in dir.get_files():
		if file_name.ends_with(".tres"):
			var res := load(RULE_DIR.path_join(file_name))
			if res is AffixRule:
				rules.append(res)


func get_valid_affixes(item_tags: int) -> Array[AffixData]:
	if _cache.has(item_tags):
		return _cache[item_tags]

	var result: Array[AffixData] = []
	for affix in affixes:
		if not _passes_own_requirements(affix, item_tags):
			continue
		if not _passes_rules(affix, item_tags):
			continue
		result.append(affix)

	_cache[item_tags] = result
	return result


func _passes_own_requirements(affix: AffixData, item_tags: int) -> bool:
	if affix.required_tags != 0 and (item_tags & affix.required_tags) != affix.required_tags:
		return false
	if affix.excluded_tags != 0 and (item_tags & affix.excluded_tags) != 0:
		return false
	return true


func _passes_rules(affix: AffixData, item_tags: int) -> bool:
	for rule in rules:
		if rule.affix_tags_governed == 0:
			continue
		if (affix.tags & rule.affix_tags_governed) == 0:
			continue # rule doesn't apply to this affix

		if rule.item_required_tags != 0 and (item_tags & rule.item_required_tags) != rule.item_required_tags:
			return false
		if rule.item_any_tags != 0 and (item_tags & rule.item_any_tags) == 0:
			return false
		if rule.item_excluded_tags != 0 and (item_tags & rule.item_excluded_tags) != 0:
			return false
	return true


### Helper functions
static func _mask_from_array(tag_list: Array[AffixData.Tags]) -> int:
	var mask := 0
	for t in tag_list:
		mask |= t
	return mask


static func has_all(mask: int, required: Array[AffixData.Tags]) -> bool:
	var required_mask := _mask_from_array(required)
	return (mask & required_mask) == required_mask


static func has_any(mask: int, any_of: Array[AffixData.Tags]) -> bool:
	return mask & _mask_from_array(any_of) != 0


static func has_none(mask: int, forbidden: Array[AffixData.Tags]) -> bool:
	return mask & _mask_from_array(forbidden) == 0
