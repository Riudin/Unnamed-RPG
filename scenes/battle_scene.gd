extends Node2D


@export var combat_player: PackedScene
@export var combat_enemy: PackedScene

@onready var player_pos: Marker2D = %PlayerPos
@onready var enemy_pos: Marker2D = %EnemyPos

@onready var victory_screen: PanelContainer = %VictoryScreen
@onready var defeat_screen: PanelContainer = %DefeatScreen

var current_player: CombatPlayer = null
var current_enemy: CombatEnemy = null


func _ready() -> void:
	victory_screen.visible = false
	defeat_screen.visible = false

	current_player = setup_player()
	current_enemy = setup_enemy()

	current_player.attack_component.target = current_enemy
	current_enemy.attack_component.target = current_player


func setup_player():
	var player = combat_player.instantiate()
	player.global_position = player_pos.global_position
	add_child(player)

	player.health_component.died.connect(_on_player_died)

	return player


func setup_enemy():
	var enemy = combat_enemy.instantiate()
	enemy.global_position = enemy_pos.global_position
	enemy.enemy_data = GameState.current_enemy
	add_child(enemy)

	enemy.health_component.died.connect(_on_enemy_died)

	return enemy


func _on_player_died(player):
	player.queue_free()
	defeat_screen.show()


func _on_enemy_died(enemy):
	#TODO: when multipla enemies possible, check if it was the last one
	enemy.queue_free()
	victory_screen.show()