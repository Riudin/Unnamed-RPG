extends Node


var player_data: PlayerData = null
# var world_state: WorldStateData = null
# var settings: SettingsData = null

var current_enemy: EnemyData = null


func _ready() -> void:
	load_save()


func save():
	ResourceSaver.save(player_data, "user://player.tres")


func load_save():
	if ResourceLoader.exists("user://player.tres"):
		player_data = ResourceLoader.load("user://player.tres")
	else:
		player_data = PlayerData.new()