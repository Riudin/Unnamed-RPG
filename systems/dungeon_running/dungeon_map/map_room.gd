class_name MapRoom
extends Area2D


signal selected(room: Room)

const ICONS := { # Keys: Type: [icon, scale]
	Room.Type.NOT_ASSIGNED: [null, Vector2.ONE],
	Room.Type.MONSTER: [preload("uid://bykjojoey3aoq"), Vector2.ONE],
	Room.Type.ELITE: [preload("uid://cglljya3defyy"), Vector2.ONE],
	Room.Type.CAMPFIRE: [preload("uid://mmfradc1utmo"), Vector2.ONE],
	Room.Type.SHRINE: [preload("uid://chxixolyhr5ey"), Vector2.ONE],
	Room.Type.BOSS: [preload("uid://b4p1j4vm8nns4"), Vector2(2.5, 2.5)],
}

@onready var sprite_2d: Sprite2D = $Visuals/Sprite2D
@onready var line_2d: Line2D = $Visuals/Line2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var available := false: set = set_available
var room: Room: set = set_room


func set_available(new_value: bool) -> void:
	available = new_value

	if available:
		animation_player.play("highlight")
	elif not room.selected:
		animation_player.play("RESET")


func set_room(new_data: Room) -> void:
	room = new_data
	position = room.position
	sprite_2d.texture = ICONS[room.type][0]
	sprite_2d.scale = ICONS[room.type][1]


func show_selected() -> void:
	line_2d.modulate = Color.WHITE


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if not available or not event.is_action_pressed("left_click"):
		return

	room.selected = true
	animation_player.play("select")


# this is called by the anim player when the select animation finishes
func _on_map_room_selected() -> void:
	selected.emit(room)
