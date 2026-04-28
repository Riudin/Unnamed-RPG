class_name UIManager
extends Node


@onready var popup_container: Node = %PopupContainer
# @onready var battle_screen: Control = %BattleScreen
@onready var inventory_ui: Control = %InventoryScreenUI
@onready var character_screen_ui: Control = %CharacterScreenUI

# LevelUI
@onready var xp_bar: TextureProgressBar = %XPBar
@onready var level_text: Label = %LevelLabel
@onready var xp_label: Label = %XPLabel

@onready var battle_confirmation_popup: PackedScene = preload("uid://clibstgxaah3l")

func _ready() -> void:
	# Battle Signals
	SignalBus.connect("enemy_clicked", _on_enemy_clicked)
	# SignalBus.connect("battle_started", _on_battle_started)
	# DamagePopupManager.connect("damage_popup_ready", _on_damage_popup_ready)

	# XP and Level Signals
	# SignalBus.leveled_up.connect(update_level_text)
	# SignalBus.xp_changed.connect(xp_bar_update)

	GameState.player_stats_changed.connect(_on_player_stats_changed)
	
	# if GameState.player_data.stats:
	# 	GameState.player_data.stats.xp_changed.connect(xp_bar_update)
	# 	GameState.player_data.stats.level_up.connect(update_level_text)


# Handling Inputs
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("open_inventory"):
		inventory_ui.visible = !inventory_ui.visible

	if event.is_action_pressed("open_character_screen"):
		character_screen_ui.visible = !character_screen_ui.visible


### Handling Combat

func _on_enemy_clicked(enemy):
	show_battle_confirmation_popup(enemy)


func show_battle_confirmation_popup(enemy):
	var popup = battle_confirmation_popup.instantiate()
	popup_container.add_child(popup)
	popup.display_popup(enemy)


# func _on_battle_started(enemy):
# 	battle_screen.enemy = enemy
# 	battle_screen.visible = true


# func _on_damage_popup_ready(popup):
# 	if battle_screen:
# 		battle_screen.add_child(popup)


### Handling XP and Level


func _on_player_stats_changed():
	if GameState.player_data.stats:
		if not GameState.player_data.stats.xp_changed.is_connected(xp_bar_update):
			GameState.player_data.stats.xp_changed.connect(xp_bar_update)
		if not GameState.player_data.stats.level_up.is_connected(update_level_text):
			GameState.player_data.stats.level_up.connect(update_level_text)

		GameState.player_data.stats.experience = GameState.player_data.stats.experience # This just calls the setter functions in stats to fire the signals and update xp ui
		update_level_text(GameState.player_data.stats.level)

func xp_bar_update(new_xp, xp_to_next, xp_floor):
	xp_bar.min_value = xp_floor
	xp_bar.max_value = xp_to_next
	xp_bar.value = new_xp

	xp_label.text = str(new_xp) + " / " + str(xp_to_next)
	print("xp: ", new_xp, " to next: ", xp_to_next)


func update_level_text(new_level):
	level_text.text = str(new_level)
	print("new level: ", new_level)
### Handling Inventory UI

# Here we can add slot highlights back in later
