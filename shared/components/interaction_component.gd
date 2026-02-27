extends Area2D


@onready var parent = get_parent()

#signal enemy_clicked(enemy)


func _ready() -> void:
	if parent == null:
		prints("No Parent found for:", self )
	

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MouseButton.MOUSE_BUTTON_LEFT and event.pressed:
			SignalBus.emit_signal("enemy_clicked", parent)
