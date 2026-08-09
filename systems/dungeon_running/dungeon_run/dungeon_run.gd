class_name DungeonRun
extends Node


const BATTLE_SCENE := preload("uid://d3quc2ajwin7n")
const BATTLE_REWARD_SCENE := preload("uid://dalbjuohh32cd")
const DUNGEON_REWARD_SCENE := preload("uid://bboqsfbfhiua4")
#const LOSE_SCENE := preload("")
const CAMPFIRE_SCENE := preload("uid://bcnputd5fu37f")
const SHRINE_SCENE := preload("uid://i1ttba237eme")


@onready var dungeon_map: DungeonMap = $DungeonMap

@onready var current_view: Node = %CurrentView
@onready var map_button: Button = %MapButton
@onready var battle_button: Button = %BattleButton
@onready var winscreen_button: Button = %WinscreenButton
@onready var losescreen_button: Button = %LosescreenButton
@onready var campfire_button: Button = %CampfireButton
@onready var shrine_button: Button = %ShrineButton
@onready var exit_button: Button = %ExitButton


func _ready() -> void:
	_start_run()


func _start_run() -> void:
	_setup_event_connections()
	dungeon_map.generate_new_map()
	dungeon_map.unlock_floor(0)


func _setup_event_connections() -> void:
	SignalBus.battle_won.connect(_change_view.bind(BATTLE_REWARD_SCENE))
	SignalBus.battle_reward_exited.connect(_show_map)
	SignalBus.campfire_room_exited.connect(_show_map)
	SignalBus.shrine_room_exited.connect(_show_map)
	#SignalBus.dungeon_boss_defeated.connect(_change_view.bind(DUNGEON_REWARD_SCENE))
	SignalBus.dungeon_map_exited.connect(_on_dungeon_map_exited)
	SignalBus.dungeon_reward_exited.connect(_on_dungeon_run_exited)

	map_button.pressed.connect(_show_map)
	battle_button.pressed.connect(_change_view.bind(BATTLE_SCENE))
	winscreen_button.pressed.connect(_change_view.bind(BATTLE_REWARD_SCENE))
	campfire_button.pressed.connect(_change_view.bind(CAMPFIRE_SCENE))
	shrine_button.pressed.connect(_change_view.bind(SHRINE_SCENE))
	exit_button.pressed.connect(_on_dungeon_run_exited)


func _change_view(scene: PackedScene) -> void:
	if current_view.get_child_count() > 0:
		for child in current_view.get_children():
			child.queue_free()

	get_tree().paused = false #TODO: we later want to pause the tree on battle over and such. here we make sure, it's unpaused again
	var new_view = scene.instantiate()
	current_view.add_child(new_view)
	
	dungeon_map.hide_map()


func _show_map() -> void: # called whenever we exit a room and go back to the map
	if current_view.get_child_count() > 0:
		for child in current_view.get_children():
			child.queue_free()
	
	dungeon_map.show_map()
	dungeon_map.unlock_next_rooms()


func _on_dungeon_map_exited(room: Room) -> void:
	match room.type:
		Room.Type.MONSTER:
			_change_view(BATTLE_SCENE)
		Room.Type.ELITE:
			_change_view(BATTLE_SCENE)
		Room.Type.CAMPFIRE:
			_change_view(CAMPFIRE_SCENE)
		Room.Type.SHRINE:
			_change_view(SHRINE_SCENE)
		Room.Type.BOSS:
			_change_view(BATTLE_SCENE)


func _on_dungeon_run_exited() -> void:
	get_tree().call_deferred("change_scene_to_file", "res://scenes/main.tscn")
