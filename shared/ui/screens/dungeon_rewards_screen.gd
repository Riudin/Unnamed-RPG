class_name DungeonRewardsScreen
extends PanelContainer


@export var slot_scene: PackedScene
@export var item_ui_scene: PackedScene

@onready var xpamount_label: Label = %XPAmount
@onready var gold_amount_label: Label = %GoldAmount
@onready var loot_display: GridContainer = %LootDisplay

var loot_items: Array[ItemInstance] = []
var gained_xp: int = 0


func _ready() -> void:
	xpamount_label.text = str(gained_xp)
	_update_loot_display()


func _update_loot_display():
	for slot in loot_display.get_children():
		slot.queue_free()
	
	for item in loot_items:
		var new_slot := slot_scene.instantiate()
		loot_display.add_child(new_slot)

		var new_item_ui := item_ui_scene.instantiate()
		new_slot.add_child(new_item_ui)
		new_item_ui.setup(item)


func _on_continue_button_pressed() -> void:
	SignalBus.dungeon_reward_exited.emit()
	#SceneManager.change_scene("main")
