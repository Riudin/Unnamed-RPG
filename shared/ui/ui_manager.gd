class_name UIManager
extends Node


@onready var popup_container: Node = %PopupContainer

@onready var battle_confirmation_popup: PackedScene = preload("uid://clibstgxaah3l")


func _ready() -> void:
	EventBus.connect("enemy_clicked", _on_enemy_clicked)


func _on_enemy_clicked(enemy):
	show_battle_confirmation_popup(enemy)


func show_battle_confirmation_popup(enemy):
	var popup = battle_confirmation_popup.instantiate()
	popup_container.add_child(popup)
	popup.display_popup(enemy)