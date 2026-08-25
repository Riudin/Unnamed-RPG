class_name DungeonRun
extends Node


const BATTLE_SCENE := preload("uid://d3quc2ajwin7n")
const BATTLE_REWARD_SCENE := preload("uid://dalbjuohh32cd")
const DUNGEON_REWARD_SCENE := preload("uid://bboqsfbfhiua4")
const DEFEAT_SCENE := preload("uid://bvacef8063haw")
const CAMPFIRE_SCENE := preload("uid://bcnputd5fu37f")
const SHRINE_SCENE := preload("uid://i1ttba237eme")


@onready var dungeon_map: DungeonMap = $DungeonMap
#@onready var dungeon_data: DungeonData = GameState.active_dungeon

@onready var current_view: Node = %CurrentView
@onready var map_button: Button = %MapButton
@onready var battle_button: Button = %BattleButton
@onready var winscreen_button: Button = %WinscreenButton
@onready var losescreen_button: Button = %LosescreenButton
@onready var campfire_button: Button = %CampfireButton
@onready var shrine_button: Button = %ShrineButton
@onready var exit_button: Button = %ExitButton

var accumulated_run_loot: Array[ItemInstance] = []
var accumulated_run_xp: int = 0


func _ready() -> void:
	assert(GameState.active_dungeon, "No DungeonData set in GameState for dungeon")
	_start_run()


func _start_run() -> void:
	_setup_event_connections()
	dungeon_map.generate_new_map()
	dungeon_map.unlock_floor(0)


func _setup_event_connections() -> void:
	SignalBus.battle_won.connect(_on_battle_won)
		#_change_view.bind(BATTLE_REWARD_SCENE))
	SignalBus.battle_reward_exited.connect(_show_map)
	SignalBus.campfire_room_exited.connect(_show_map)
	SignalBus.shrine_room_exited.connect(_show_map)
	SignalBus.dungeon_boss_defeated.connect(_on_dungeon_boss_defeated)
		#_change_view.bind(DUNGEON_REWARD_SCENE))
	SignalBus.dungeon_map_exited.connect(_on_dungeon_map_exited)
	SignalBus.dungeon_reward_exited.connect(_on_dungeon_run_exited)
	SignalBus.dungeon_failed.connect(_change_view.bind(DEFEAT_SCENE))

	map_button.pressed.connect(_show_map)
	battle_button.pressed.connect(_change_view.bind(BATTLE_SCENE))
	winscreen_button.pressed.connect(_change_view.bind(BATTLE_REWARD_SCENE))
	campfire_button.pressed.connect(_change_view.bind(CAMPFIRE_SCENE))
	shrine_button.pressed.connect(_change_view.bind(SHRINE_SCENE))
	exit_button.pressed.connect(_on_dungeon_run_exited)


func _on_battle_won(loot: Array[ItemInstance] = [], xp: int = 0) -> void:
	# Accumulate loot and xp from the last battle and save it in the run to display at the end
	for item in loot:
		accumulated_run_loot.append(item)

	accumulated_run_xp += xp

	# check if theres a battle scene, if so, stop its processing. delete all other views
	for child in current_view.get_children():
		if child is BattleScene:
			child.process_mode = Node.PROCESS_MODE_DISABLED
		else:
			child.queue_free()

	# add the rewards scene on top of the battle scene. when continue is pressed, both will be deleted by _change_view()
	var reward_scene = BATTLE_REWARD_SCENE.instantiate()
	reward_scene.loot_items = loot
	reward_scene.gained_xp = xp
	current_view.add_child(reward_scene)


func _on_dungeon_boss_defeated(loot: Array[ItemInstance] = [], xp: int = 0) -> void:
	# Accumulate loot and xp from the last battle and save it in the run to display at the end
	for item in loot:
		accumulated_run_loot.append(item)

	accumulated_run_xp += xp

	# check if theres a battle scene, if so, stop its processing. delete all other views
	for child in current_view.get_children():
		if child is BattleScene:
			child.process_mode = Node.PROCESS_MODE_DISABLED
		else:
			child.queue_free()

	# add the rewards scene on top of the battle scene. when continue is pressed, both will be deleted by _change_view()
	var reward_scene = DUNGEON_REWARD_SCENE.instantiate()
	reward_scene.loot_items = accumulated_run_loot
	reward_scene.gained_xp = accumulated_run_xp
	current_view.add_child(reward_scene)


func _change_view(scene: PackedScene, room: Room = null) -> Node:
	if current_view.get_child_count() > 0:
		for child in current_view.get_children():
			child.queue_free()

	get_tree().paused = false # TODO: we later want to pause the tree on battle over and such. here we make sure, it's unpaused again
	var new_view = scene.instantiate()
	if new_view is BattleScene:
		new_view.enemy_level = room.enemy_level
	current_view.add_child(new_view)
	
	dungeon_map.hide_map()
	
	return new_view


func _show_map() -> void: # called whenever we exit a room and go back to the map
	if current_view.get_child_count() > 0:
		for child in current_view.get_children():
			child.queue_free()
	
	dungeon_map.show_map()
	dungeon_map.unlock_next_rooms()


func _on_dungeon_map_exited(room: Room) -> void:
	match room.type:
		Room.Type.MONSTER:
			GameState.active_battle_type = BattleScene.BattleType.NORMAL
			_change_view(BATTLE_SCENE, room)
		Room.Type.ELITE:
			GameState.active_battle_type = BattleScene.BattleType.ELITE
			_change_view(BATTLE_SCENE, room)
		Room.Type.BOSS:
			GameState.active_battle_type = BattleScene.BattleType.BOSS
			_change_view(BATTLE_SCENE, room)
		Room.Type.CAMPFIRE:
			_change_view(CAMPFIRE_SCENE)
		Room.Type.SHRINE:
			_change_view(SHRINE_SCENE)


func _on_dungeon_run_exited() -> void:
	get_tree().call_deferred("change_scene_to_file", "res://scenes/main.tscn")
