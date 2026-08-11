class_name DungeonData
extends Resource


@export var normal_enemy_pool: Array[EnemyData]
@export var elite_enemy_pool: Array[EnemyData]
@export var boss_enemy_pool: Array[EnemyData]

@export var min_enemies: int = 1
@export var max_enemies: int = 4

@export var min_enemy_level: int = 1
@export var max_enemy_level: int = 100
