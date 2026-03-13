class_name BattleManager
extends Node


# UI references
@onready var battle_screen: Control = %BattleScreen

# Combatant entities
@onready var battle_entity: PackedScene = preload("uid://bdsupgb8khl7q")
@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("player")
var player_battle_entity: BattleEntity = null
var enemy_battle_entity: BattleEntity = null
var current_opponent = null


func start_battle(enemy):
	current_opponent = enemy
	player_battle_entity = battle_entity.instantiate()
	player_battle_entity.add_to_group("battle_entity")
	player_battle_entity.attribute_data = player.attribute_data
	player_battle_entity.damage_data = player.damage_data
	player_battle_entity.global_position = battle_screen.player_damage_popup_marker.global_position
	add_child(player_battle_entity)
	player_battle_entity.health_component.connect("died", _on_entity_died)

	enemy_battle_entity = battle_entity.instantiate()
	enemy_battle_entity.add_to_group("battle_entity")
	enemy_battle_entity.enemy_data = enemy.enemy_data
	enemy_battle_entity.attribute_data = enemy.attribute_data
	enemy_battle_entity.damage_data = enemy.damage_data
	enemy_battle_entity.drop_table = enemy.drop_table
	enemy_battle_entity.global_position = battle_screen.enemy_damage_popup_marker.global_position
	add_child(enemy_battle_entity)
	enemy_battle_entity.health_component.connect("died", _on_entity_died)

	# TODO: This should be set based on a system in an own method, when there's more possible targets
	player_battle_entity.attack_component.target = enemy_battle_entity
	enemy_battle_entity.attack_component.target = player_battle_entity

	
	# Notify the UI that battle started and pass the entities
	battle_screen._on_battle_started(player_battle_entity, enemy_battle_entity)


func _on_entity_died(entity):
	# TODO: when group battles are implemented, check if it was the last enemy
	if entity.enemy_data != null: # entity is an enemy
		# Generate Loot
		var loot: ItemInstance = LootGenerator.generate_loot(entity.drop_table)

		if loot:
			InventoryManager.add_item(loot)
			# print(loot.get_display_name())
			# print("Rarity: ", loot.rarity)
			# print("Affixes: ", loot.rolled_stats)
		
		# Grant player XP reward
		if player.leveling_component != null:
			player.leveling_component.add_xp(entity.drop_table.xp_reward)

		# Inform battle_screen that victory happened and what was looted
		battle_screen.show_victory_screen(loot)

		# Delete enemy (not battle entity but enemy in world)
		current_opponent.queue_free()
	
	var entities = get_tree().get_nodes_in_group("battle_entity")
	for e in entities:
		e.queue_free()
