class_name DungeonMap
extends Node2D

const SCROLL_SPEED := 15
const MAP_ROOM = preload("uid://mr6fmpfyx2jx")
const MAP_LINE = preload("uid://b0uvfer5swyon")

@onready var map_generator: Node = $MapGenerator
@onready var lines: Node2D = %Lines
@onready var rooms: Node2D = %Rooms
@onready var visuals: Node2D = $Visuals
@onready var camera_2d: Camera2D = $Camera2D

var map_data: Array[Array]
var floors_cleared: int
var last_room: Room
var camera_edge_x: float


func _ready() -> void:
	camera_edge_x = MapGenerator.X_DIST * (MapGenerator.FLOORS - 1)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("scroll_right") and camera_2d.enabled:
		camera_2d.position.x += SCROLL_SPEED
	elif event.is_action_pressed("scroll_left") and camera_2d.enabled:
		camera_2d.position.x -= SCROLL_SPEED

	camera_2d.position.x = clamp(camera_2d.position.x, 0, camera_edge_x)


func generate_new_map() -> void:
	floors_cleared = 0
	map_data = map_generator.generate_map(GameState.active_dungeon)
	create_map()


func create_map() -> void:
	for current_floor: Array in map_data:
		for room: Room in current_floor:
			if room.next_rooms.size() > 0:
				_spawn_room(room)
	
	# Handle boss room because next_rooms will be empty for this one
	var middle := floori(MapGenerator.MAP_WIDTH * 0.5)
	_spawn_room(map_data[MapGenerator.FLOORS - 1][middle])

	var map_height_pixels := MapGenerator.Y_DIST * (MapGenerator.MAP_WIDTH - 1)
	visuals.position.x = get_viewport_rect().size.x / 5
	visuals.position.y = (get_viewport_rect().size.y + map_height_pixels) / 2


func unlock_floor(floor_to_unlock: int = floors_cleared) -> void:
	for map_room: MapRoom in rooms.get_children():
		if map_room.room.column == floor_to_unlock:
			map_room.available = true


func unlock_next_rooms() -> void:
	for map_room: MapRoom in rooms.get_children():
		if last_room.next_rooms.has(map_room.room):
			map_room.available = true


func show_map() -> void:
	show()
	camera_2d.enabled = true


func hide_map() -> void:
	hide()
	camera_2d.enabled = false


func _spawn_room(room: Room) -> void:
	var new_map_room := MAP_ROOM.instantiate() as MapRoom
	rooms.add_child(new_map_room)
	new_map_room.room = room
	new_map_room.selected.connect(_on_map_room_selected)
	_connect_lines(room)

	# this is for loading a map that is not yet completed for example on game load
	if room.selected and room.column < floors_cleared:
		new_map_room.show_selected()


func _connect_lines(room: Room) -> void:
	if room.next_rooms.is_empty():
		return
	
	for next: Room in room.next_rooms:
		var new_map_line := MAP_LINE.instantiate() as Line2D
		new_map_line.add_point(room.position)
		new_map_line.add_point(next.position)
		lines.add_child(new_map_line)


func _on_map_room_selected(room: Room) -> void:
	for map_room: MapRoom in rooms.get_children():
		if map_room.room.column == room.column:
			map_room.available = false

	last_room = room
	floors_cleared += 1
	SignalBus.dungeon_map_exited.emit(room)
