extends PanelContainer


@export var slot_scene: PackedScene

@onready var xpamount_label: Label = %XPAmount
@onready var gold_amount_label: Label = %GoldAmount
@onready var loot_display: GridContainer = %LootDisplay

var loot_items: Array[ItemInstance] = []


func update_loot_display():
	for slot in loot_display.get_children():
		slot.queue_free()
	
	for item in loot_items:
		var new_slot: InventorySlot = slot_scene.instantiate()
		loot_display.add_child(new_slot)
		new_slot.set_current_item(item)
