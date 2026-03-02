class_name BattleEntity
extends Node


@onready var health_component: HealthComponent = %HealthComponent
@onready var attack_component: AttackComponent = %AttackComponent

var combat_stats: CombatStats = null


func _ready() -> void:
	health_component.connect("died", _on_death)


func _on_death():
	print(self.name, "died")
	queue_free()
