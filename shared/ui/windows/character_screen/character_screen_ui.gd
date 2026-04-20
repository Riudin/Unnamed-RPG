class_name CharacterScreenUI
extends PanelContainer


@export var player: Player

@onready var equipment_screen: Control = %EquipmentScreen
@onready var crafting_screen: Control = %CraftingScreen
@onready var skill_screen: Control = %SkillScreen
@onready var stat_screen: Control = %StatScreen


func _ready() -> void:
	_on_equipment_screen_button_pressed()


func _on_equipment_screen_button_pressed() -> void:
	equipment_screen.show()
	skill_screen.show()
	crafting_screen.hide()
	stat_screen.hide()


func _on_crafting_screen_button_pressed() -> void:
	equipment_screen.hide()
	skill_screen.hide()
	crafting_screen.show()
	stat_screen.hide()


func _on_stat_screen_button_pressed() -> void:
	equipment_screen.hide()
	skill_screen.show()
	crafting_screen.hide()
	stat_screen.show()
