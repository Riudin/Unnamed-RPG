class_name DungeonRun
extends Node


const BATTLE_SCENE := preload("uid://d3quc2ajwin7n")
const BATTLE_REWARD_SCENE := preload("uid://dalbjuohh32cd")
#const LOSE_SCENE := preload("")
const CAMPFIRE_SCENE := preload("uid://bcnputd5fu37f")
const SHRINE_SCENE := preload("uid://i1ttba237eme")
const MAP_SCENE := preload("uid://bi7wgyruic004")

@onready var current_view: Node = %CurrentView
@onready var map_button: Button = %MapButton
@onready var battle_button: Button = %BattleButton
@onready var winscreen_button: Button = %WinscreenButton
@onready var losescreen_button: Button = %LosescreenButton
@onready var campfire_button: Button = %CampfireButton
@onready var shrine_button: Button = %ShrineButton


func _ready() -> void:
	_start_run()


func _start_run() -> void:
	_setup_event_connections()
	print("TODO: Generate new map")


func _setup_event_connections() -> void:
	SignalBus.battle_won.connect(_change_view.bind(BATTLE_REWARD_SCENE))
	SignalBus.battle_reward_exited.connect(_change_view.bind(MAP_SCENE))
	SignalBus.campfire_room_exited.connect(_change_view.bind(MAP_SCENE))
	SignalBus.shrine_room_exited.connect(_change_view.bind(MAP_SCENE))
	#SignalBus.dungeon_map_exited.connect(_on_dungeon_map_exited)

	map_button.pressed.connect(_change_view.bind(MAP_SCENE))
	battle_button.pressed.connect(_change_view.bind(BATTLE_SCENE))
	winscreen_button.pressed.connect(_change_view.bind(BATTLE_REWARD_SCENE))
	campfire_button.pressed.connect(_change_view.bind(CAMPFIRE_SCENE))
	shrine_button.pressed.connect(_change_view.bind(SHRINE_SCENE))


func _change_view(scene: PackedScene) -> void:
	if current_view.get_child_count() > 0:
		for child in current_view.get_children():
			child.queue_free()

	get_tree().paused = false #TODO: we later want to pause the tree on battle over and such. here we make sure, it's unpaused again
	var new_view = scene.instantiate()
	current_view.add_child(new_view)


func _on_dungeon_map_exited() -> void:
	print("dungeon map exited")
