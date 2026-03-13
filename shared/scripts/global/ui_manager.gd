class_name UIManager
extends Node


@onready var popup_container: Node = %PopupContainer
@onready var battle_screen: Control = %BattleScreen
@onready var inventory_ui: Control = %InventoryUI

# LevelUI
@onready var xp_bar: TextureProgressBar = %XPBar
@onready var level_text: Label = %LevelLabel

@onready var battle_confirmation_popup: PackedScene = preload("uid://clibstgxaah3l")
@onready var item_info_popup: PackedScene = preload("uid://b60rc4rdpir0a")

var active_item_info_popup = null

func _ready() -> void:
	# Battle Signals
	SignalBus.connect("enemy_clicked", _on_enemy_clicked)
	SignalBus.connect("battle_started", _on_battle_started)
	SignalBus.inventory_slot_mouse_entered.connect(_on_inventory_slot_mouse_entered)
	SignalBus.inventory_slot_mouse_exited.connect(_on_inventory_slot_mouse_exited)
	DamagePopupManager.connect("damage_popup_ready", _on_damage_popup_ready)

	# XP and Level Signals
	SignalBus.leveled_up.connect(update_level_text)
	SignalBus.xp_changed.connect(xp_bar_update)


# Handling Inputs
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("inventory"):
		inventory_ui.visible = !inventory_ui.visible


### Handling Combat

func _on_enemy_clicked(enemy):
	show_battle_confirmation_popup(enemy)


func show_battle_confirmation_popup(enemy):
	var popup = battle_confirmation_popup.instantiate()
	popup_container.add_child(popup)
	popup.display_popup(enemy)


func _on_battle_started(enemy):
	battle_screen.enemy = enemy
	battle_screen.visible = true


func _on_damage_popup_ready(popup):
	if battle_screen:
		battle_screen.add_child(popup)


### Handling XP and Level

func update_level_text(new_level, _levels_gained, _skill_points_awarded):
	level_text.text = str(new_level)
 

func xp_bar_update(new_xp, xp_to_next):
	xp_bar.max_value = xp_to_next
	xp_bar.value = new_xp


### Handling Inventory UI

func _on_inventory_slot_mouse_entered(slot):
	if active_item_info_popup == null:
		var popup = item_info_popup.instantiate()
		active_item_info_popup = popup
		popup_container.add_child(popup)


func _on_inventory_slot_mouse_exited(_slot):
	if active_item_info_popup != null:
		active_item_info_popup.queue_free()
