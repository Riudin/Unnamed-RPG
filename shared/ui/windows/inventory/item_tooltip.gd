class_name ItemTooltip
extends Control


const AFFIX_DISPLAY_SCENE: PackedScene = preload("uid://bg1poyp2sb4j3")

# @onready var item_icon = %ItemIcon
@onready var item_name_label = %ItemName
@onready var nameplate: NinePatchRect = %Nameplate
@onready var content: VBoxContainer = %Content

# Margin Containers
@onready var item_specifics: Control = %ItemSpecificStats
@onready var requirements: Control = %Requirements
@onready var implicits: Control = %Implicits
@onready var affixes: Control = %Affixes

# Label Containers
@onready var implicit_stats = %ImplicitStats
@onready var item_affixes = %ItemAffixes

var displayed_item: ItemInstance = null # we store the displayed item here just so we can run set_item again on input
var display_details: bool = false


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("display_details"):
		display_details = true
		set_item(displayed_item)
	elif event.is_action_released("display_details"):
		display_details = false
		set_item(displayed_item)


func set_item(item: ItemInstance):
	displayed_item = item

	# Nameplate
	item_name_label.text = item.get_display_name()
	item_name_label.modulate = item.get_color()
	nameplate.custom_minimum_size.x = item_name_label.get_minimum_size().x + 16.0

	_set_implicits(item)
	_set_affixes(item)
	_resize_to_content()


func _set_implicits(item: ItemInstance) -> void:
	_clear_stats(implicit_stats)
	if item.base.implicit_modifiers.is_empty():
		implicits.visible = false
		return
	else:
		implicits.visible = true

	for i in item.base.implicit_modifiers:
		var display = AFFIX_DISPLAY_SCENE.instantiate()
		implicit_stats.add_child(display)
		display.set_description("Implicit Modifier")
		display.description.visible = false if not display_details else true

		for mod in i.mods:
			if display_details:
				display.set_text(mod.get_display_text_comprehensive())
			else:
				display.set_text(mod.get_display_text())


func _set_affixes(item: ItemInstance) -> void:
	_clear_stats(item_affixes)
	if item.prefixes.is_empty() and item.suffixes.is_empty():
		affixes.visible = false
		return
	else:
		affixes.visible = true

	for p in item.prefixes:
		#if not p: continue
		var display = AFFIX_DISPLAY_SCENE.instantiate()
		item_affixes.add_child(display)
		display.set_description("Prefix Tier " + str(p.tier))
		display.description.visible = false if not display_details else true

		for mod in p.mods:
			if display_details:
				display.set_text(mod.get_display_text_comprehensive())
			else:
				display.set_text(mod.get_display_text())

			#var l := Label.new()
			# l.text = mod.get_display_text()
			# # l.text = _format_stat(stat_name, value)
			# l.add_theme_font_size_override("font_size", 8) # Workaround to set font size. Maybe in the future use a predefinded label scene
			# item_affixes_box.add_child(l)
	
	for s in item.suffixes:
		var display = AFFIX_DISPLAY_SCENE.instantiate()
		item_affixes.add_child(display)
		display.set_description("Suffix Tier " + str(s.tier))
		display.description.visible = false if not display_details else true

		for mod in s.mods:
			if display_details:
				display.set_text(mod.get_display_text_comprehensive())
			else:
				display.set_text(mod.get_display_text())

			# var l := Label.new()
			# l.text = mod.get_display_text()
			# # l.text = _format_stat(stat_name, value)
			# l.add_theme_font_size_override("font_size", 8) # Workaround to set font size. Maybe in the future use a predefinded label scene
			# item_affixes_box.add_child(l)


func _resize_to_content() -> void:
	var content_size := content.get_combined_minimum_size()
	size = Vector2(max(custom_minimum_size.x, content_size.x), content_size.y)


func _clear_stats(container: Control):
	for c in container.get_children():
		if c is HSeparator:
			continue
		
		c.free()


func _format_stat(stat_name: String, value: float) -> String:
	var display := stat_name.replace("_", " ").capitalize()

	if stat_name.ends_with("_pct"):
		return "+%d%% %s" % [round(value), display.replace(" Pct", "")]
	
	return "+%d %s" % [round(value), display]
