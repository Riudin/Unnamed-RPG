extends TextureRect


func _ready() -> void:
	for dungeon in get_tree().get_nodes_in_group("dungeons"):
		dungeon.clicked.connect(_on_dungeon_clicked)


func _on_dungeon_clicked(dungeon_data):
	SignalBus.dungeon_clicked.emit(dungeon_data)


func _on_exit_button_pressed() -> void:
	visible = false
