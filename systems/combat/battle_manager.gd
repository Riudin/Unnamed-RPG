class_name BattleManager
extends Node


@onready var parent = get_parent()

var tick_counter: int = 0

var player_stats: CombatStats = null
var enemy_stats: CombatStats = null

var in_combat: bool = false


func _ready() -> void:
	TickManager.connect("tick", _on_tick)


func _on_tick():
	if not in_combat:
		return
	
	tick_counter += 1

	if tick_counter >= TickManager.tick_rate / 30: # TODO: remove placeholder
			tick_counter = 0
			# code that runs on tick based - timer here
			prints("player dmg:", player_stats.damage)
			prints("enemy dmg:", enemy_stats.damage)


func update():
	player_stats = parent.player.combat_stats
	enemy_stats = parent.enemy.combat_stats
