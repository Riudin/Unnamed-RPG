class_name BattleManager
extends Node
### DEPRECATED
'''


# UI references
# @onready var battle_screen: Control = %BattleScreen

# Combatant entities
@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("player")
#var current_opponent = null


func _ready() -> void:
	await player.ready


func start_battle(enemy):
	enemy.health_component.connect("died", _on_entity_died)

	# TODO: This should be set based on a system in an own method, when there's more possible targets
	player.attack_component.target = enemy
	enemy.attack_component.target = player


func _on_entity_died(entity):
	# TODO: when group battles are implemented, check if it was the last enemy
	if entity.enemy_data != null: # entity is an enemy
		# Generate Loot
		var loot: ItemInstance = LootGenerator.generate_loot(entity.drop_table)

		if loot:
			InventoryManager.add_item(loot)
		
		# Grant player XP reward
		if player.leveling_component != null:
			player.leveling_component.add_xp(entity.drop_table.xp_reward)

		# Inform battle_screen that victory happened and what was looted
		# TODO: figure out if the fight was a boss and if so emit dungeon_boss_defeated instead.
		SignalBus.battle_won.emit(loot)

		# Reset player health
		player.health_component.health = player.health_component.max_health

		# Delete enemy
		entity.queue_free()
	
	else: # entity is the player
		entity.health_component.health = entity.health_component.max_health
'''
