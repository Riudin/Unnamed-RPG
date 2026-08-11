class_name CombatEnemy
extends Node2D


@onready var sprite: Sprite2D = %Sprite2D
@onready var attack_component: AttackComponent = %AttackComponent
@onready var health_component: HealthComponent = %HealthComponent
@onready var resource_bars: VBoxContainer = %ResourceBars
@onready var enemy_name: Label = %Name
@onready var enemy_level: Label = %Level
@onready var name_display: VBoxContainer = %NameDisplay


var enemy_data: EnemyData = null


func _ready() -> void:
	assert(enemy_data != null, "No EnemyData set for " + str(self ))
	if not enemy_data.stats:
		print("EnemyData has no stats. Using default stats")
		enemy_data.stats = Stats.new()
	
	attack_component.parent_data = enemy_data
	health_component.parent_data = enemy_data

	sprite.texture = enemy_data.texture
	enemy_name.text = str(enemy_data.name)
	enemy_level.text = "lvl: " + str(enemy_data.stats.monster_level)
	if enemy_data.type == EnemyData.EnemyType.BOSS:
		_scale_boss_visuals()


func _scale_boss_visuals() -> void:
	sprite.scale *= 2
	sprite.position.y *= 2
	resource_bars.position.y = sprite.position.y
	name_display.position.y += resource_bars.position.y


func on_visual_hit():
	health_component.on_visual_hit()
