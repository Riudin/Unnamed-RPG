class_name CharacterScreenUI
extends PanelContainer


@export var player: Player


func _ready() -> void:
	# This idea doesn't work yet because the slots are not direct children. Maybe later.
	for c in get_children():
		if c is EquipmentSlot:
			c.player = player