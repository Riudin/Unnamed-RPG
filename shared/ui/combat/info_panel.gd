class_name InfoPanel
extends Control


signal died(panel: InfoPanel)

@onready var content: Control = %Content
@onready var name_label: Label = %NameLabel
@onready var icon: TextureRect = %Icon
@onready var icon_slash: TextureRect = %Slash
@onready var health_bar: StatBar = %HealthBar
@onready var health_bar_label: Label = %HealthBarLabel
@onready var mana_bar: StatBar = %ManaBar
@onready var mana_bar_label: Label = %ManaBarLabel
@onready var status_effect_display: Control = %StatusEffectDisplay
@onready var combat_skill_bar: Control = %CombatSkillBar
@onready var line_anchor: Marker2D = %OwnershipLineAnchor

var is_dead: bool = false
var associated_entity: Node2D

@export var enemy_name: String:
	set(new_value):
		enemy_name = new_value
		if name_label:
			name_label.text = enemy_name

@export var entity_y_position: float # used for ordering the panels

@export var max_health: float:
	set(new_value):
		max_health = new_value
		if health_bar:
			health_bar.setup_bar(max_health, max_health)
		if health_bar_label:
			health_bar_label.text = str(int(max_health)) + " / " + str(int(max_health))


func _on_health_changed(new_health: float) -> void:
	if health_bar:
		health_bar.update_bar(float(new_health), float(max_health))
	
	if health_bar_label:
		health_bar_label.text = str(int(new_health)) + " / " + str(int(max_health))

	if new_health <= 0:
		_on_death()


func _on_death() -> void:
	if is_dead:
		return
	is_dead = true
	died.emit(self)
	icon_slash.show()

	var mat := ShaderMaterial.new()
	mat.shader = load("res://shared/shaders/desaturate.gdshader")

	icon.material = mat
	health_bar.front_bar.material = mat
	health_bar.back_bar.material = mat
	mana_bar.front_bar.material = mat
	mana_bar.back_bar.material = mat
	
	for effect in status_effect_display.get_children():
		effect.queue_free()

	if content:
		content.modulate = Color(0.2, 0.2, 0.2, 1.0)