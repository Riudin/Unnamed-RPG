extends CanvasLayer


@onready var save_slots: Control = %SaveSlots
@onready var mode_switch: Control = %ModeSwitch


func _ready() -> void:
	visible = false


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode == KEY_ESCAPE and event.is_pressed():
			visible = !visible
			if visible:
				mode_switch.visible = visible
				save_slots.visible = not visible