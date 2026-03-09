class_name BattleEntity
extends Node


@onready var health_component: HealthComponent = %HealthComponent
@onready var attack_component: AttackComponent = %AttackComponent

var enemy_data: EnemyData = null
var attribute_data: AttributeData = null
var damage_data: DamageData = null

var attack_speed: float = 1.0 # Placeholder

var global_position: Vector2 = Vector2.ZERO # Workaround for the damage popup because this is not a node2d with a global position
