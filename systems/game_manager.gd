class_name GameManager
extends Node


@onready var battle_manager: Node = %BattleManager
@onready var ui_manager: Node = %UIManager
@onready var enemy_container: Node = %EnemyContainer


func _ready() -> void:
	SignalBus.battle_started.connect(_on_battle_started)
	#battle_manager.connect("battle_won", _on_battle_won)


func _on_battle_started(enemy):
	battle_manager.start_battle(enemy)


# func _on_battle_won(opponent):
# 	opponent.queue_free()
