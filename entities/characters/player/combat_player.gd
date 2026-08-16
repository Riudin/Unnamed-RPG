class_name CombatPlayer
extends Node2D


@onready var player_data: PlayerData = GameState.player_data

@onready var attack_component: AttackComponent = %AttackComponent
@onready var health_component: HealthComponent = %HealthComponent
@onready var status_effect_component: StatusEffectComponent = %StatusEffectComponent

#@onready var mana_bar: TextureProgressBar = %ManaBar


func _ready() -> void:
	assert(player_data != null, "No PlayerData set")
	if not player_data.stats:
		print("PlayerData has no stats. Using default stats")
		player_data.stats = Stats.new()

	attack_component.parent_data = player_data
	health_component.parent_data = player_data


func on_visual_hit():
	health_component.on_visual_hit()
