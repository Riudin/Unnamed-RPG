class_name BattleScene
extends Node2D


@export var combat_player: PackedScene
@export var combat_enemy: PackedScene

@onready var player_pos: Marker2D = %PlayerPos
@onready var enemy_pos_1: Marker2D = %EnemyPos1
@onready var enemy_pos_2: Marker2D = %EnemyPos2
@onready var enemy_pos_3: Marker2D = %EnemyPos3
@onready var enemy_pos_4: Marker2D = %EnemyPos4
@onready var enemy_pos_5: Marker2D = %EnemyPos5
@onready var enemy_positions: Array[Vector2] = [
	enemy_pos_1.global_position,
	enemy_pos_2.global_position,
	enemy_pos_3.global_position,
	enemy_pos_4.global_position,
	enemy_pos_5.global_position
]

var current_player: CombatPlayer = null
var current_enemy: CombatEnemy = null
var active_enemies: Array[CombatEnemy] = []

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


func _setup_enemy(data: EnemyData) -> void:
	var new_enemy = combat_enemy.instantiate()
	
	assert(enemy_positions.size() > 0, "Trying to instatiate more enemies than there are possible positions")
	new_enemy.global_position = enemy_positions.pick_random()
	enemy_positions.erase(new_enemy.global_position)
	
	new_enemy.enemy_data = data
	new_enemy.enemy_data.stats.monster_level = randi_range(dungeon_data.min_enemy_level, dungeon_data.max_enemy_level)
	if new_enemy.enemy_data.type == EnemyData.EnemyType.BOSS:
		new_enemy.enemy_data.stats.monster_level = dungeon_data.max_enemy_level
		
	add_child(new_enemy)
	active_enemies.append(new_enemy)

	new_enemy.health_component.died.connect(_on_enemy_died)
	new_enemy.attack_component.target = current_player
	
	current_enemy = new_enemy # temporary just so there is a target for the player


func _setup_enemies() -> void:
	match battle_type:
		BattleType.NORMAL:
			var amount := randi_range(dungeon_data.min_enemies, dungeon_data.max_enemies)
			for enemy in amount:
				_setup_enemy(dungeon_data.normal_enemy_pool.pick_random())
		BattleType.ELITE:
			var total_amount := randi_range(dungeon_data.min_enemies, dungeon_data.max_enemies)
			var elite_amount :=randi_range(dungeon_data.min_enemies, total_amount)
			for elite in elite_amount:
				_setup_enemy(dungeon_data.elite_enemy_pool.pick_random())
			for normal in total_amount - elite_amount:
				_setup_enemy(dungeon_data.normal_enemy_pool.pick_random())
		BattleType.BOSS:
			_setup_enemy(dungeon_data.boss_enemy_pool.pick_random())


func _on_player_died(player):
	SignalBus.dungeon_failed.emit()
	player.queue_free()


func _on_enemy_died(enemy: CombatEnemy):
	#TODO: when multiple enemies possible, check if it was the last one
	var loot: ItemInstance = LootGenerator.generate_loot(enemy.enemy_data.drop_table)

	if loot:
		InventoryManager.add_item(loot)
	
	# Grant player XP reward
	if GameState.player_data.stats:
		GameState.player_data.stats.experience += enemy.enemy_data.drop_table.xp_reward
	
	active_enemies.erase(enemy)
	if active_enemies.is_empty():
		match enemy.enemy_data.type:
			EnemyData.EnemyType.NORMAL:
				SignalBus.battle_won.emit()
			EnemyData.EnemyType.ELITE:
				SignalBus.battle_won.emit()
			EnemyData.EnemyType.BOSS:
				SignalBus.dungeon_boss_defeated.emit()
	else:
		current_player.attack_component.target = active_enemies.pick_random()
			
	enemy.queue_free()
