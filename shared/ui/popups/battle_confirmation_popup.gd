extends PopupPanel


@onready var name_label: Label = %NameLabel
@onready var enemy_icon: TextureRect = %EnemyIcon

var enemy


func display_popup(enemy_data):
	enemy = enemy_data
	name_label.text = enemy.enemy_data.name
	enemy_icon.texture = enemy.sprite.texture
	popup_centered()
