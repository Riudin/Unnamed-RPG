extends Button


enum MODE {SAVE, LOAD}
@export var mode := MODE.SAVE

@onready var player = get_tree().get_first_node_in_group("player")
@onready var save_ui = $"../.."


func _ready() -> void:
	var time = SaveManager.get_slot_time(get_index())

	if time != null:
		text = "%02d.%02d.%04d %02d:%02d" % [time.day, time.month, time.year, time.hour, time.minute]
	else:
		text = "Empty Slot"


func _get_datetime_string() -> String:
	var dt = Time.get_datetime_dict_from_system()

	return "%02d.%02d.%04d %02d:%02d" % [dt.day, dt.month, dt.year, dt.hour, dt.minute]


func _on_pressed() -> void:
	if mode == MODE.SAVE:
		SaveManager.save_game(
			get_index(),
			player
		)
		text = _get_datetime_string()
	
	elif mode == MODE.LOAD:
		SaveManager.load_game(
			get_index(),
			player
		)

	save_ui.visible = false
