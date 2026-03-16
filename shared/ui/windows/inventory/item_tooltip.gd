class_name ItemTooltip
extends PanelContainer

@onready var item_icon = %ItemIcon
@onready var item_name_label = %ItemName
@onready var item_rarity_label = %ItemRarity
@onready var item_stats_box = %ItemStats


func set_item(item: ItemInstance):
	item_icon.texture = item.base.icon
	item_name_label.text = item.get_display_name()
	item_name_label.modulate = item.get_color()
	item_rarity_label.text = LootEnums.Rarity.keys()[item.rarity]

	_clear_stats()

	for stat in item.rolled_stats:
		var l := Label.new()
		l.text = "%s : %.2f" % [stat.stat_name, item.rolled_stats[stat]]
		l.add_theme_font_size_override("font_size", 8) # Workaround to set font size. Maybe in the future use a predefinded label scene
		item_stats_box.add_child(l)


func _clear_stats():
	for c in item_stats_box.get_children():
		c.queue_free()
