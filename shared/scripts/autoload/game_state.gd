extends Node


signal player_stats_changed # TODO: this feels like spaghetti. check if the signal is needed at all or should be emitted elsewhere


var player_data: PlayerData = null:
	set(new_value):
		if player_data != null and player_data.stats_changed.is_connected(_on_player_stats_changed):
			player_data.stats_changed.disconnect(_on_player_stats_changed)

		player_data = new_value

		if player_data != null:
			player_data.stats_changed.connect(_on_player_stats_changed)
			
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


func _on_player_stats_changed() -> void:
	player_stats_changed.emit()