class_name ItemTooltip
extends PanelContainer

@onready var item_icon = %ItemIcon
@onready var item_name_label = %ItemName
@onready var item_stats_box = %ItemStats


func set_item(item: ItemInstance):
	item_icon.texture = item.base.icon
	item_name_label.text = item.get_display_name()
	item_name_label.modulate = item.get_color()

	_clear_stats()

	# for stat_name in item.rolled_stats.keys():
	# 	var value = item.rolled_stats[stat_name]

	for p in item.prefixes:
		for mod in p.mods:
			var l := Label.new()
			l.text = mod.get_display_text()
			# l.text = _format_stat(stat_name, value)
			l.add_theme_font_size_override("font_size", 8) # Workaround to set font size. Maybe in the future use a predefinded label scene
			item_stats_box.add_child(l)


func _clear_stats():
	for c in item_stats_box.get_children():
		c.queue_free()


func _format_stat(stat_name: String, value: float) -> String:
	var display := stat_name.replace("_", " ").capitalize()

	if stat_name.ends_with("_pct"):
		return "+%d%% %s" % [round(value), display.replace(" Pct", "")]
	
	return "+%d %s" % [round(value), display]
