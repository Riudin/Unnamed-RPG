extends Node2D


@export var combat_player: PackedScene
@export var combat_enemy: PackedScene

@onready var player_pos: Marker2D = %PlayerPos
@onready var enemy_pos: Marker2D = %EnemyPos

var current_player: CombatPlayer = null
var current_enemy: CombatEnemy = null


func _ready() -> void:
	current_player = setup_player()
	current_enemy = setup_enemy()

	current_player.attack_component.target = current_enemy
	current_enemy.attack_component.target = current_player


func setup_player():
	var player = combat_player.instantiate()
	player.global_position = player_pos.global_position
	add_child(player)
	return player


func setup_enemy():
	var enemy = combat_enemy.instantiate()
	enemy.global_position = enemy_pos.global_position
	enemy.enemy_data = GameState.current_enemy
	add_child(enemy)
	return enemy
