class_name GameManager
extends Node


@onready var battle_manager: Node = %BattleManager
@onready var ui_manager: Node = %UIManager


func _ready() -> void:
	SignalBus.battle_started.connect(_on_battle_started)


func _on_battle_started(enemy):
	battle_manager.start_battle(enemy)
