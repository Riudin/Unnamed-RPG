extends Control


@onready var player_icon: TextureRect = %PlayerIcon
@onready var enemy_icon_1: TextureRect = %EnemyIcon1
@onready var player_attack_bar: ProgressBar = %PlayerAttackBar
@onready var enemy_attack_bar: ProgressBar = %EnemyAttackBar

var player: CharacterBody2D = null
var enemy: CharacterBody2D = null: set = set_enemy

var player_entity: BattleEntity = null
var enemy_entity: BattleEntity = null


func _ready() -> void:
    player = get_tree().get_first_node_in_group("player") # assumes only one player
    player_icon.texture = player.sprite.texture
    
    # Set up progress bars to use 0-1 scale
    player_attack_bar.min_value = 0.0
    player_attack_bar.max_value = 1.0
    player_attack_bar.value = 0.0
    
    enemy_attack_bar.min_value = 0.0
    enemy_attack_bar.max_value = 1.0
    enemy_attack_bar.value = 0.0


func set_enemy(e):
    # for now only one enemy
    enemy = e
    enemy_icon_1.texture = enemy.enemy_data.texture


func _on_battle_started(player_ent: BattleEntity, enemy_ent: BattleEntity) -> void:
    player_entity = player_ent
    enemy_entity = enemy_ent
    
    # Connect progress signals from both entities
    player_entity.connect("progress_changed", Callable(self , "_on_player_progress_changed"))
    enemy_entity.connect("progress_changed", Callable(self , "_on_enemy_progress_changed"))
    
    # Reset bars to 0
    player_attack_bar.value = 0.0
    enemy_attack_bar.value = 0.0


func _on_player_progress_changed(progress: float) -> void:
    player_attack_bar.value = progress


func _on_enemy_progress_changed(progress: float) -> void:
    enemy_attack_bar.value = progress