class_name UIManager
extends Node


@onready var popup_container: Node = %PopupContainer
@onready var battle_screen: Control = %BattleScreen


@onready var battle_confirmation_popup: PackedScene = preload("uid://clibstgxaah3l")


func _ready() -> void:
	SignalBus.connect("enemy_clicked", _on_enemy_clicked)
	SignalBus.connect("battle_started", _on_battle_started)


func _on_enemy_clicked(enemy):
	show_battle_confirmation_popup(enemy)


func show_battle_confirmation_popup(enemy):
	var popup = battle_confirmation_popup.instantiate()
	popup_container.add_child(popup)
	popup.display_popup(enemy)


func _on_battle_started(enemy):
	battle_screen.enemy = enemy
	battle_screen.visible = true
