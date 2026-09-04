class_name BattleScene
extends Node2D


# signal enemy_instantiated(enemy: CombatEnemy)
# signal player_instantiated(player: CombatPlayer)
# signal summon_instantiated(summon: CombatSummon)

@export var combat_player: PackedScene
@export var combat_enemy: PackedScene
@export var combat_summon: PackedScene

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
@onready var ally_pos_1: Marker2D = %AllyPos1
@onready var ally_pos_2: Marker2D = %AllyPos2
@onready var ally_pos_3: Marker2D = %AllyPos3
@onready var ally_pos_4: Marker2D = %AllyPos4
@onready var ally_positions: Array[Vector2] = [
	ally_pos_1.global_position,
	ally_pos_2.global_position,
	ally_pos_3.global_position,
	ally_pos_4.global_position
]
@onready var battle_ui: BattleUI = %UI

var current_player: CombatPlayer = null
# var current_enemy: CombatEnemy = null
var active_enemies: Array[CombatEnemy] = []
var active_summons: Array[CombatSummon] = []
var enemy_level: int = 0

var accumulated_loot: Array[ItemInstance] = []
var accumulated_xp: int = 0

@onready var dungeon_data: DungeonData = GameState.active_dungeon
enum BattleType {NORMAL, ELITE, BOSS}
@onready var battle_type: BattleType = GameState.active_battle_type


func _ready() -> void:
	GameState.player_data.active_skill = null # we have this variable atm for the skillscreen display. if we don't set it to null, the skills values get applied to combat twice

	current_player = _setup_player()
	_setup_enemies()

	#current_player.attack_component.target = current_enemy
	# current_enemy.attack_component.target = current_player

	SignalBus.summon_requested.connect(_setup_summon)


func _setup_player():
	var player = combat_player.instantiate()
	player.global_position = player_pos.global_position
	add_child(player)

	player.health_component.died.connect(_on_player_died)

	# player_instantiated.emit(player)
	return player


func _setup_enemy(data: EnemyData) -> void:
	var new_enemy = combat_enemy.instantiate()
	
	assert(enemy_positions.size() > 0, "Trying to instatiate more enemies than there are possible positions")
	new_enemy.global_position = enemy_positions.pick_random()
	enemy_positions.erase(new_enemy.global_position)
	
	new_enemy.enemy_data = data.duplicate(true)
	if new_enemy.enemy_data.stats != null:
		new_enemy.enemy_data.stats = data.stats.duplicate(true)
	new_enemy.enemy_data.level = enemy_level
		
	add_child(new_enemy)
	active_enemies.append(new_enemy)

	new_enemy.health_component.died.connect(_on_enemy_died)
	new_enemy.attack_component.target = current_player
	
	# enemy_instantiated.emit(new_enemy)
	battle_ui.display_enemy_info(new_enemy)

	# current_enemy = new_enemy # temporary just so there is a target for the player
	current_player.attack_component.target = active_enemies.pick_random()


func _setup_enemies() -> void:
	match battle_type:
		BattleType.NORMAL:
			var amount := randi_range(dungeon_data.min_enemies, dungeon_data.max_enemies)
			for enemy in amount:
				_setup_enemy(dungeon_data.normal_enemy_pool.pick_random())
			battle_ui.sort_enemy_panels()
			
		BattleType.ELITE:
			var total_amount := randi_range(dungeon_data.min_enemies, dungeon_data.max_enemies)
			var elite_amount := randi_range(dungeon_data.min_enemies, total_amount)
			for elite in elite_amount:
				_setup_enemy(dungeon_data.elite_enemy_pool.pick_random())
			for normal in total_amount - elite_amount:
				_setup_enemy(dungeon_data.normal_enemy_pool.pick_random())
			battle_ui.sort_enemy_panels()

		BattleType.BOSS:
			_setup_enemy(dungeon_data.boss_enemy_pool.pick_random())
			battle_ui.sort_enemy_panels()


func _setup_summon(summon_data: EnemyData) -> void:
	var new_summon = combat_summon.instantiate()

	if ally_positions.size() <= 0: return
	
	new_summon.global_position = ally_positions.pick_random()
	ally_positions.erase(new_summon.global_position)
	
	new_summon.enemy_data = summon_data

	add_child(new_summon)
	active_summons.append(new_summon)

	new_summon.health_component.died.connect(_on_summon_died)
	new_summon.attack_component.target = active_enemies.pick_random()

	battle_ui.display_summon_info(new_summon)
	battle_ui.sort_summon_panels()

	### TEMPORARY to let enemies target summons as well
	# var enemy_targets: Array[Node2D] = []
	# enemy_targets.append(current_player)
	# for summon in active_summons:
	# 	enemy_targets.append(summon)
	# for enemy in active_enemies:
	# 	enemy.attack_component.target = enemy_targets.pick_random()
	
	# when a summon in summoned, every enemy has a 20% chance to switch targets to it
	for enemy in active_enemies:
		if randf() <= 1.0:
			enemy.attack_component.target = new_summon


func _on_player_died(player):
	Engine.time_scale = 1.0
	SignalBus.dungeon_failed.emit()
	player.queue_free()


func _on_enemy_died(enemy: CombatEnemy):
	# Generate loot
	var loot_items: Array[ItemInstance] = LootGenerator.generate_loot(enemy.enemy_data)

	if loot_items.size() > 0:
		for item in loot_items:
			InventoryManager.add_item(item)
			accumulated_loot.append(item)
	
	# Grant player XP reward
	if GameState.player_data.stats:
		GameState.player_data.stats.experience += 10 # TODO: just for debugging!
		#enemy.enemy_data.drop_table.xp_reward
	
	accumulated_xp += 10 # TODO: just for debugging!
	#enemy.enemy_data.drop_table.xp_reward
	
	# End Battle if it was the last enemy
	active_enemies.erase(enemy)
	if active_enemies.is_empty():
		match enemy.enemy_data.type:
			EnemyData.EnemyType.NORMAL:
				Engine.time_scale = 1.0
				SignalBus.battle_won.emit(accumulated_loot, accumulated_xp)
			EnemyData.EnemyType.ELITE:
				Engine.time_scale = 1.0
				SignalBus.battle_won.emit(accumulated_loot, accumulated_xp)
			EnemyData.EnemyType.BOSS:
				Engine.time_scale = 1.0
				SignalBus.dungeon_boss_defeated.emit()
	else:
		# Give Player new target - temporary
		current_player.attack_component.target = active_enemies.pick_random()
		# Give Summons new target - temporary
		for summon in active_summons:
			if summon.attack_component.target == enemy:
				summon.attack_component.target = active_enemies.pick_random()

	# Delete killed enemy		
	enemy.queue_free()


func _on_summon_died(summon: CombatSummon) -> void:
	active_summons.erase(summon)

	# make the ally position available again
	ally_positions.append(summon.global_position)

	# when a summon dies, every enemy that fought it gets a random new target
	var enemy_targets: Array[Node2D] = []
	enemy_targets.append(current_player)
	for s in active_summons:
		enemy_targets.append(s)

	for enemy in active_enemies:
		if enemy.attack_component.target == summon:
			enemy.attack_component.target = enemy_targets.pick_random()

	summon.queue_free()
