extends Control


# Assets to display
@onready var player_icon: TextureRect = %PlayerIcon
@onready var enemy_icon_1: TextureRect = %EnemyIcon1
@onready var player_attack_bar: ProgressBar = %PlayerAttackBar
@onready var enemy_attack_bar: ProgressBar = %EnemyAttackBar
@onready var player_health_bar: TextureProgressBar = %PlayerHealthBar
@onready var enemy_health_bar: TextureProgressBar = %EnemyHealthBar
@onready var player_damage_popup_marker: Marker2D = %PlayerDamagePopupMarker
@onready var enemy_damage_popup_marker: Marker2D = %EnemyDamagePopupMarker

# Screens
@onready var battle_display: Control = %BattleDisplay
@onready var victory_screen: Control = %VictoryScreen
@onready var defeat_screen: Control = %DefeatScreen

# Combatants
var player: Node = null: set = set_player
var enemy: Node = null: set = set_enemy


func _ready() -> void:
	# make all screens invisible, they should be turned visible when needed
	visible = false
	battle_display.visible = false
	victory_screen.visible = false
	defeat_screen.visible = false

	# reference to the player is static at the moment. will need to change when multiplayer or teamfights are implemented
	player = get_tree().get_first_node_in_group("player")
	player.attack_component.connect("progress_changed", _on_player_progress_changed)
	player.health_component.connect("health_changed", _on_player_health_changed)
	player.health_component.connect("died", _on_player_died)


func set_player(p):
	player = p
	player_icon.texture = player.sprite.texture
	player_health_bar.max_value = player.health_component.max_health
	player_health_bar.value = player.health_component.health


func set_enemy(e):
	# for now only one enemy
	enemy = e
	enemy_icon_1.texture = enemy.enemy_data.texture
	enemy_health_bar.max_value = enemy.health_component.max_health
	enemy_health_bar.value = enemy.health_component.health


func _on_battle_started(p: Node, e: Node) -> void:
	visible = true
	battle_display.visible = true

	player = p
	enemy = e

	# Connect progress signals from enemy
	enemy.attack_component.connect("progress_changed", _on_enemy_progress_changed)
	enemy.health_component.connect("health_changed", _on_enemy_health_changed)

	# Reset bars
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


# TODO: handle both dying at the same time
func _on_player_died(_player):
	battle_display.visible = false
	defeat_screen.visible = true


func show_victory_screen(loot):
	battle_display.visible = false
	# victory_screen.loot_items.clear()
	# print(loot)
	# victory_screen.loot_items.append(loot)
	# victory_screen.update_loot_display()
	victory_screen.visible = true


func _on_victory_screen_continue_button_pressed() -> void:
	victory_screen.visible = false
	visible = false


func _on_defeat_screen_continue_button_pressed() -> void:
	defeat_screen.visible = false
	visible = false
