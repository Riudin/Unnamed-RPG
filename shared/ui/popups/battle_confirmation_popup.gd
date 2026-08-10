extends PopupPanel
###DEPRECATED
'''


@onready var name_label: Label = %NameLabel
@onready var enemy_icon: TextureRect = %EnemyIcon

@onready var orc_enemy_data: Resource = preload("uid://b2juo74fyf2wm") # TODO: this is a placeholder until different enemies are stored somewhere

var enemy: WorldEnemy = null


func display_popup(clicked_enemy):
	var data: EnemyData = null
	if clicked_enemy is WorldEnemy:
		data = clicked_enemy.enemy_data
	else:
		data = orc_enemy_data

	GameState.current_enemy = data
	name_label.text = data.name
	enemy_icon.texture = data.texture
	popup_centered()


func _on_confirm_button_pressed() -> void:
	SceneManager.change_scene("battle_scene")
	#SignalBus.emit_signal("battle_started", enemy)
	queue_free()


func _on_cancel_button_pressed() -> void:
	GameState.current_enemy = null
	queue_free()


func _on_popup_hide() -> void:
	queue_free()
'''
