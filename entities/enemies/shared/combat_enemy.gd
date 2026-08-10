class_name CombatEnemy
extends Node2D


@onready var sprite: Sprite2D = %Sprite2D
@onready var attack_component: AttackComponent = %AttackComponent
@onready var health_component: HealthComponent = %HealthComponent

var enemy_data: EnemyData = null


func _ready() -> void:
	assert(enemy_data != null, "No EnemyData set for " + str(self ))
	if not enemy_data.stats:
		print("EnemyData has no stats. Using default stats")
		enemy_data.stats = Stats.new()
	
	attack_component.parent_data = enemy_data
	health_component.parent_data = enemy_data

	sprite.texture = enemy_data.texture


func on_visual_hit():
	health_component.on_visual_hit()
