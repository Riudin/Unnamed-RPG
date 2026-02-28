class_name BattleManager
extends Node


@onready var battle_screen: Control = %BattleScreen

var tick_counter: int = 0

var player_stats: CombatStats = null
var enemy_stats: CombatStats = null

var in_combat: bool = false

var player_battle_entity: BattleEntity = null
var enemy_battle_entity: BattleEntity = null


func _ready() -> void:
	TickManager.connect("tick", _on_tick)
	add_to_group("battle_manager")


func _on_tick():
	if not in_combat:
		return
	
	tick_counter += 1

	if tick_counter >= TickManager.tick_rate / 30: # TODO: remove placeholder
		tick_counter = 0
		# code that runs on tick based - timer here


func start_battle(enemy):
	player_battle_entity = BattleEntity.new()
	player_battle_entity.combat_stats = get_tree().get_first_node_in_group("player").combat_stats

	enemy_battle_entity = BattleEntity.new()
	enemy_battle_entity.combat_stats = enemy.combat_stats

	# Connect attack signals for damage resolution
	player_battle_entity.connect("attack_ready", Callable(self , "_on_player_attack"))
	enemy_battle_entity.connect("attack_ready", Callable(self , "_on_enemy_attack"))

	in_combat = true
	
	# Notify the UI that battle started and pass the entities
	battle_screen._on_battle_started(player_battle_entity, enemy_battle_entity)


func _on_player_attack():
	if enemy_battle_entity and player_battle_entity:
		print("enemy takes damage")
		#enemy_battle_entity.health_component.take_damage(player_battle_entity.combat_stats.damage)


func _on_enemy_attack():
	if player_battle_entity and enemy_battle_entity:
		print("player takes damage")
		#player_battle_entity.health_component.take_damage(enemy_battle_entity.combat_stats.damage)
