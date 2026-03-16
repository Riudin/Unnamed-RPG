class_name InventorySlot
extends Control


@export var grid_pos: Vector2i

#@onready var item_icon_display: TextureRect = %ItemIconDisplay
@onready var highlight: ColorRect = %Highlight

func _highlight():
	highlight.visible = true
	

func _unhighlight():
	highlight.visible = false
