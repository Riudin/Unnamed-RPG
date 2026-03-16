extends Panel

@onready var ItemIcon = $MarginContainer/VBoxContainer/HBoxContainer/ItemIcon
@onready var ItemName = $MarginContainer/VBoxContainer/HBoxContainer/ItemName
@onready var ItemText = $MarginContainer/VBoxContainer/InfoText


func _show_pop(item, pos):
	visible = true
	global_position = pos
	ItemIcon.texture = item.base.icon
	ItemName.clear()
	ItemName.append_text(item.base.name)
	#ItemText.clear()
	#ItemText.append_text(item.base.type)   -> need to convert from enum to correct type string

func _hide_pop():
	visible = false
