extends Node


var player_data: PlayerData = null
# var world_state: WorldStateData = null
# var settings: SettingsData = null

var current_enemy: EnemyData = null


func _ready() -> void:
	load_data()


func save_data():
	ResourceSaver.save(player_data, "user://save_data/player.tres")


func load_data():
	if ResourceLoader.exists("user://save_data/player.tres"):
		player_data = ResourceLoader.load("user://save_data/player.tres")
	else:
		player_data = PlayerData.new()
