### Credit to GodotGameLab on Youtube for the incredible tutorial: https://www.youtube.com/watch?v=7HYu7QXBuCY
class_name MapGenerator
extends Node


const X_DIST := 60
const Y_DIST := 40
const PLACEMENT_RANDOMNESS := 15
const FLOORS := 15
const MAP_WIDTH := 7
const PATHS := 6
const MINIMUM_UNIQUE_STARTING_POINTS := 2
const MONSTER_ROOM_WEIGHT := 10.0
const ELITE_ROOM_WEIGHT := 2.5
const CAMPFIRE_ROOM_WEIGHT := 4.0
const SHRINE_ROOM_WEIGHT := 3.0

var random_room_type_weights = {
	Room.Type.MONSTER: 0.0,
	Room.Type.ELITE: 0.0,
	Room.Type.CAMPFIRE: 0.0,
	Room.Type.SHRINE: 0.0
}
var random_room_type_total_weight := 0
var map_data: Array[Array]


func generate_map() -> Array[Array]:
	map_data = _generate_initial_grid()
	var starting_points := _get_random_starting_points()

	for j in starting_points:
		var current_j := j
		for i in FLOORS - 1:
			current_j = _setup_connection(i, current_j)

	_setup_boss_room()
	_setup_random_room_weights()
	_setup_room_types()

	# Debugging
	'''
	var i := 0
	for f in map_data:
		print("floor %s" % i)
		var used_rooms = f.filter(
			func(room: Room): return room.next_rooms.size() > 0
		)
		print(used_rooms)
		i += 1
	'''

	return map_data


func _generate_initial_grid() -> Array[Array]:
	var result: Array[Array] = []

	for i in FLOORS:
		var adjacent_rooms: Array[Room] = []

		for j in MAP_WIDTH:
			var current_room := Room.new()
			var offset := Vector2(randf(), randf()) * PLACEMENT_RANDOMNESS
			current_room.position = Vector2(i * X_DIST, j * -Y_DIST) + offset
			current_room.row = j
			current_room.column = i
			current_room.next_rooms = []

			# Boss room 
			if i == FLOORS - 1:
				current_room.position.x = (i + 1) * X_DIST
			
			adjacent_rooms.append(current_room)
		
		result.append(adjacent_rooms)
	
	return result


func _get_random_starting_points() -> Array[int]:
	var y_coordinates: Array[int]
	var unique_points: int = 0

	while unique_points < MINIMUM_UNIQUE_STARTING_POINTS:
		unique_points = 0
		y_coordinates = []

		for i in PATHS:
			var starting_point := randi_range(0, MAP_WIDTH - 1)
			if not y_coordinates.has(starting_point):
				unique_points += 1
			
			y_coordinates.append(starting_point)
	
	return y_coordinates


func _setup_connection(i: int, j: int) -> int:
	var next_room: Room = null
	var current_room := map_data[i][j] as Room
	
	while not next_room or _would_cross_existing_path(i, j, next_room):
		var random_j := clampi(randi_range(j - 1, j + 1), 0, MAP_WIDTH - 1)
		next_room = map_data[i + 1][random_j]

	current_room.next_rooms.append(next_room)

	return next_room.row


func _would_cross_existing_path(i: int, j: int, room: Room) -> bool:
	var top_neighbour: Room
	var bottom_neighbour: Room

	# if j == 0, there is no top neighbour
	if j > 0:
		top_neighbour = map_data[i][j - 1]
	
	# if j == MAP_WIDTH - 1, there is no bottom neighbour
	if j < MAP_WIDTH - 1:
		bottom_neighbour = map_data[i][j + 1]

	# can't cross downwards if bottom neighbour goes up
	if bottom_neighbour and room.row > j:
		for next_room: Room in bottom_neighbour.next_rooms:
			if next_room.row < room.row:
				return true
	
	# can't cross upwards if top neighbour goes down
	if top_neighbour and room.row < j:
		for next_room: Room in top_neighbour.next_rooms:
			if next_room.row > room.row:
				return true
	
	return false


func _setup_boss_room() -> void:
	var middle := floori(MAP_WIDTH * 0.5)
	var boss_room := map_data[FLOORS - 1][middle] as Room

	# connect all rooms on second to last floor to the boss room
	for j in MAP_WIDTH:
		var current_room = map_data[FLOORS - 2][j] as Room
		if current_room.next_rooms:
			current_room.next_rooms = [] as Array[Room]
			current_room.next_rooms.append(boss_room)

	boss_room.type = Room.Type.BOSS


func _setup_random_room_weights() -> void:
	random_room_type_weights[Room.Type.MONSTER] = MONSTER_ROOM_WEIGHT
	random_room_type_weights[Room.Type.ELITE] = MONSTER_ROOM_WEIGHT + ELITE_ROOM_WEIGHT
	random_room_type_weights[Room.Type.CAMPFIRE] = MONSTER_ROOM_WEIGHT + ELITE_ROOM_WEIGHT + CAMPFIRE_ROOM_WEIGHT
	random_room_type_weights[Room.Type.SHRINE] = MONSTER_ROOM_WEIGHT + ELITE_ROOM_WEIGHT + CAMPFIRE_ROOM_WEIGHT + SHRINE_ROOM_WEIGHT

	random_room_type_total_weight = random_room_type_weights[Room.Type.SHRINE]


func _setup_room_types() -> void:
	# first floor is always a Monster Type
	for room: Room in map_data[0]:
		if room.next_rooms.size() > 0:
			room.type = Room.Type.MONSTER
	
	# middle floor is always a shrine
	# for room: Room in map_data[floori(FLOORS * 0.5)]:
	# 	if room.next_rooms.size() > 0:
	# 		room.type = Room.Type.SHRINE

	# last floor before the boss is always a campfire
	for room: Room in map_data[FLOORS - 2]:
		if room.next_rooms.size() > 0:
			room.type = Room.Type.CAMPFIRE
	
	# rest of rooms
	for current_floor in map_data:
		for room: Room in current_floor:
			for next_room: Room in room.next_rooms:
				if next_room.type == Room.Type.NOT_ASSIGNED:
					_set_room_randomly(next_room)

			
func _set_room_randomly(room_to_set: Room) -> void:
	var campfire_before_floor_4 := true # there can't be campfires before floor 4
	var consecutive_campfire := true # there can't be consecutive campfires
	var consecutive_shrine := true # there can't be consecutive shops
	var campfire_2_before_boss := true # there can't be a campfire 2 rooms before the boss because that would always result in consecutive campfires

	var type_candidate: Room.Type

	# continue rolling as long as any of the above rules is violated
	while campfire_before_floor_4 or consecutive_campfire or consecutive_shrine or campfire_2_before_boss:
		type_candidate = _get_random_room_type_by_weight()

		var is_campfire := type_candidate == Room.Type.CAMPFIRE
		var has_campfire_parent := _room_has_parent_of_type(room_to_set, Room.Type.CAMPFIRE)
		var is_shrine := type_candidate == Room.Type.SHRINE
		var has_shrine_parent := _room_has_parent_of_type(room_to_set, Room.Type.SHRINE)

		campfire_before_floor_4 = is_campfire and room_to_set.column < 3
		consecutive_campfire = is_campfire and has_campfire_parent
		consecutive_shrine = is_shrine and has_shrine_parent
		campfire_2_before_boss = is_campfire and room_to_set.column == FLOORS - 3

	room_to_set.type = type_candidate


func _room_has_parent_of_type(room: Room, type: Room.Type) -> bool:
	var parents: Array[Room] = []

	# top parent
	if room.row > 0 and room.column > 0:
		var parent_candidate := map_data[room.column - 1][room.row - 1] as Room
		if parent_candidate.next_rooms.has(room):
			parents.append(parent_candidate)
	
	# left parent
	if room.column > 0:
		var parent_candidate := map_data[room.column - 1][room.row] as Room
		if parent_candidate.next_rooms.has(room):
			parents.append(parent_candidate)
	
	# bottom parent
	if room.row < MAP_WIDTH - 1 and room.column > 0:
		var parent_candidate := map_data[room.column - 1][room.row + 1] as Room
		if parent_candidate.next_rooms.has(room):
			parents.append(parent_candidate)
	
	for parent: Room in parents:
		if parent.type == type:
			return true
	
	return false


func _get_random_room_type_by_weight() -> Room.Type:
	var roll := randf_range(0.0, random_room_type_total_weight)

	for type: Room.Type in random_room_type_weights:
		if random_room_type_weights[type] > roll:
			return type

	return Room.Type.MONSTER
