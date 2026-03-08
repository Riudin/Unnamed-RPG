class_name BattleManager
extends Node


# Signals
signal battle_won(opponent)

# UI references
@onready var battle_screen: Control = %BattleScreen

# # Combatant stats
# var player_attributes: AttributeData = null
# var enemy_attributes: AttributeData = null

# Combatant entities
@onready var battle_entity: PackedScene = preload("uid://bdsupgb8khl7q")
var player_battle_entity: BattleEntity = null
var enemy_battle_entity: BattleEntity = null
var current_opponent = null


func start_battle(enemy):
	current_opponent = enemy
	player_battle_entity = battle_entity.instantiate()
	player_battle_entity.attribute_data = get_tree().get_first_node_in_group("player").attribute_data
	player_battle_entity.damage_data = get_tree().get_first_node_in_group("player").damage_data
	# player_battle_entity.active_skill = get_tree().get_first_node_in_group("player").active_skill
	add_child(player_battle_entity)

	enemy_battle_entity = battle_entity.instantiate()
	enemy_battle_entity.attribute_data = enemy.attribute_data
	enemy_battle_entity.damage_data = enemy.damage_data
	# enemy_battle_entity.active_skill = enemy.active_skill
	add_child(enemy_battle_entity)

	# TODO: This should be set based on a system in an own method, when there's more possible targets
	player_battle_entity.attack_component.target = enemy_battle_entity
	enemy_battle_entity.attack_component.target = player_battle_entity

	# Connect attack signals for damage resolution TODO: connect to singular resolving func
	# player_battle_entity.attack_component.connect("attack_ready", _on_player_attack)
	# enemy_battle_entity.attack_component.connect("attack_ready", _on_enemy_attack)

	player_battle_entity.health_component.connect("died", _on_player_died)
	enemy_battle_entity.health_component.connect("died", _on_enemy_died)
	
	# Notify the UI that battle started and pass the entities
	battle_screen._on_battle_started(player_battle_entity, enemy_battle_entity)


# func _on_player_attack(target, dmg_info):
# 	if target is BattleEntity:
# 		print("Player attacks for ", dmg_info.damage, " damage of type ", dmg_info.type)
# 		target.health_component.take_damage(dmg_info.damage)


# func _on_enemy_attack(target, dmg_info):
# 	if target is BattleEntity:
# 		print("Enemy attacks for ", dmg_info.damage, " damage of type ", dmg_info.type)
# 		target.health_component.take_damage(dmg_info.damage)


func _on_player_died():
	enemy_battle_entity.queue_free()


func _on_enemy_died():
	# TODO: when group battles are implemented, check if it was the last enemy
	emit_signal("battle_won", current_opponent)
	player_battle_entity.queue_free()
