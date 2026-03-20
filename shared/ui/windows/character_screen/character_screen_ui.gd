class_name CharacterScreenUI
extends PanelContainer


@export var player: Player

@onready var equipment_screen: Control = %EquipmentScreen
@onready var crafting_screen: Control = %CraftingScreen


func _ready() -> void:
	# This idea doesn't work yet because the slots are not direct children. Maybe later.
	for c in get_children():
		if c is EquipmentSlot:
			c.player = player

	equipment_screen.visible = true
	crafting_screen.visible = false


func _on_equipment_screen_button_pressed() -> void:
	equipment_screen.visible = true
	crafting_screen.visible = false


func _on_crafting_screen_button_pressed() -> void:
	equipment_screen.visible = false
	crafting_screen.visible = true
