extends Control


@onready var player_icon: TextureRect = %PlayerIcon
@onready var enemy_icon_1: TextureRect = %EnemyIcon1
@onready var battle_manager: BattleManager = $BattleManager

var player: CharacterBody2D = null
var enemy: CharacterBody2D = null: set = set_enemy


func _ready() -> void:
	player = get_tree().get_first_node_in_group("player") # assumes only one player
	player_icon.texture = player.sprite.texture
	

func set_enemy(e):
	# for now only one enemy
	enemy = e
	enemy_icon_1.texture = enemy.enemy_data.texture
	start_battle()


func start_battle():
	battle_manager.in_combat = true
	battle_manager.update()