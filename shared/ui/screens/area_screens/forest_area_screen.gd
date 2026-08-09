extends Control


const DUNGEON_RUN_SCENE_PATH := "res://systems/dungeon_running/dungeon_run/dungeon_run.tscn"


func _ready() -> void:
	for dungeon in get_tree().get_nodes_in_group("dungeons"):
		dungeon.clicked.connect(_on_dungeon_clicked)


func _on_dungeon_clicked(dungeon_data):
	#SignalBus.dungeon_clicked.emit(dungeon_data)
	get_tree().call_deferred("change_scene_to_file", DUNGEON_RUN_SCENE_PATH)


func _on_exit_button_pressed() -> void:
	visible = false
