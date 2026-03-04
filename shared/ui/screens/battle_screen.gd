extends Control


# Assets to display
@onready var player_icon: TextureRect = %PlayerIcon
@onready var enemy_icon_1: TextureRect = %EnemyIcon1
@onready var player_attack_bar: ProgressBar = %PlayerAttackBar
@onready var enemy_attack_bar: ProgressBar = %EnemyAttackBar
@onready var player_health_bar: TextureProgressBar = %PlayerHealthBar
@onready var enemy_health_bar: TextureProgressBar = %EnemyHealthBar

# Screens
@onready var battle_display: Control = %BattleDisplay
@onready var victory_screen: Control = %VictoryScreen
@onready var defeat_screen: Control = %DefeatScreen

# Combatants
var player: CharacterBody2D = null: set = set_player
var player_battle_entity: BattleEntity = null
var enemy: CharacterBody2D = null: set = set_enemy
var enemy_battle_entity: BattleEntity = null


func _ready() -> void:
	# make all screens invisible, they should be turned visible when needed
	visible = false
	battle_display.visible = false
	victory_screen.visible = false
	defeat_screen.visible = false

	# reference to the player is static at the moment. will need to change when multiplayer or teamfights are implemented
	player = get_tree().get_first_node_in_group("player")


func set_player(p):
	player = p
	player_icon.texture = player.sprite.texture
	player_health_bar.max_value = player.combat_stats.max_health
	player_health_bar.value = player.combat_stats.max_health


func set_enemy(e):
	# for now only one enemy
	enemy = e
	enemy_icon_1.texture = enemy.enemy_data.texture
	enemy_health_bar.max_value = enemy.combat_stats.max_health
	enemy_health_bar.value = enemy.combat_stats.max_health


func _on_battle_started(player_ent: BattleEntity, enemy_ent: BattleEntity) -> void:
	visible = true
	battle_display.visible = true
	player_battle_entity = player_ent
	enemy_battle_entity = enemy_ent

	# Connect progress signals from both entities
	player_battle_entity.attack_component.connect("progress_changed", _on_player_progress_changed)
	enemy_battle_entity.attack_component.connect("progress_changed", _on_enemy_progress_changed)
	player_battle_entity.health_component.connect("health_changed", _on_player_health_changed)
	enemy_battle_entity.health_component.connect("health_changed", _on_enemy_health_changed)
	player_battle_entity.health_component.connect("died", _on_player_died)
	enemy_battle_entity.health_component.connect("died", _on_enemy_died)

	# Reset bars to 0
	player_attack_bar.value = 0.0
	enemy_attack_bar.value = 0.0


func _on_player_progress_changed(progress: float) -> void:
	player_attack_bar.value = progress


func _on_enemy_progress_changed(progress: float) -> void:
	enemy_attack_bar.value = progress


func _on_player_health_changed(health):
	player_health_bar.value = health


func _on_enemy_health_changed(health):
	enemy_health_bar.value = health


func _on_player_died():
	battle_display.visible = false
	defeat_screen.visible = true


func _on_enemy_died():
	battle_display.visible = false
	victory_screen.visible = true


func _on_victory_screen_continue_button_pressed() -> void:
	victory_screen.visible = false
	visible = false


func _on_defeat_screen_continue_button_pressed() -> void:
	defeat_screen.visible = false
	visible = false