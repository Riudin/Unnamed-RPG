extends PopupPanel


@onready var name_label: Label = %NameLabel
@onready var enemy_icon: TextureRect = %EnemyIcon

var enemy


func display_popup(clicked_enemy):
	enemy = clicked_enemy
	name_label.text = enemy.enemy_data.name
	enemy_icon.texture = enemy.enemy_data.texture
	popup_centered()


func _on_confirm_button_pressed() -> void:
	SignalBus.emit_signal("battle_started", enemy)
	queue_free()


func _on_cancel_button_pressed() -> void:
	queue_free()


func _on_popup_hide() -> void:
	queue_free()
