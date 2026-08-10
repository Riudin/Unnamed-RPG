class_name BattleScene
extends Node2D


@export var combat_player: PackedScene
@export var combat_enemy: PackedScene

@onready var player_pos: Marker2D = %PlayerPos
@onready var enemy_pos: Marker2D = %EnemyPos

var current_player: CombatPlayer = null
var current_enemy: CombatEnemy = null

@onready var dungeon_data: DungeonData = GameState.active_dungeon
enum BattleType {NORMAL, ELITE, BOSS}
@onready var battle_type: BattleType = GameState.active_battle_type


func _ready() -> void:
	GameState.player_data.active_skill = null # we have this variable atm for the skillscreen display. if we don't set it to null, the skills values get applied to combat twice

	current_player = _setup_player()
	_setup_enemies()

	current_player.attack_component.target = current_enemy
	current_enemy.attack_component.target = current_player


func _setup_player():
	var player = combat_player.instantiate()
	player.global_position = player_pos.global_position
	add_child(player)

	player.health_component.died.connect(_on_player_died)

	return player


func _setup_enemy(enemy: EnemyData) -> void:
	# TODO: tell the battle scene what enemy should be instantiated
	var new_enemy = combat_enemy.instantiate()
	new_enemy.global_position = enemy_pos.global_position
	new_enemy.enemy_data = enemy
	add_child(new_enemy)

	new_enemy.health_component.died.connect(_on_enemy_died)
	
	current_enemy = new_enemy # temporary just so there is a target for the player


func _setup_enemies() -> void:
	match battle_type:
		BattleType.NORMAL:
			_setup_enemy(dungeon_data.normal_enemy_pool.pick_random())
		BattleType.ELITE:
			_setup_enemy(dungeon_data.elite_enemy_pool.pick_random())
		BattleType.BOSS:
			_setup_enemy(dungeon_data.boss_enemy_pool.pick_random())


func _on_player_died(player):
	player.queue_free()


func _on_enemy_died(enemy):
	#TODO: when multiple enemies possible, check if it was the last one
	var loot: ItemInstance = LootGenerator.generate_loot(enemy.enemy_data.drop_table)

	if loot:
		InventoryManager.add_item(loot)
	
	# Grant player XP reward
	if GameState.player_data.stats:
		GameState.player_data.stats.experience += enemy.enemy_data.drop_table.xp_reward
	
	match enemy.enemy_data.type:
		EnemyData.EnemyType.NORMAL:
			SignalBus.battle_won.emit()
		EnemyData.EnemyType.ELITE:
			SignalBus.battle_won.emit()
		EnemyData.EnemyType.BOSS:
			SignalBus.dungeon_boss_defeated.emit()
			
	enemy.queue_free()
