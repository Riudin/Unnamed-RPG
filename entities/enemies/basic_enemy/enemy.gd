class_name Enemy
extends CharacterBody2D


@export var enemy_data: EnemyData
@onready var attribute_data: AttributeData = enemy_data.attribute_data
@onready var drop_table: ItemDropTable = enemy_data.drop_table
@onready var damage_data: DamageData = enemy_data.damage_data

@onready var sprite: Sprite2D = %Sprite2D
@onready var nav_timer: Timer = %NavigationTimer

@onready var movement_component: MovementComponent = %MovementComponent
@onready var navigation_component: NavigationComponent = %NavigationComponent
@onready var animation_component: AnimationComponent = %AnimationComponent
@onready var health_component: HealthComponent = %HealthComponent
@onready var attack_component: AttackComponent = %AttackComponent

var initial_position: Vector2 = Vector2.ZERO


func _ready() -> void:
	if enemy_data == null:
		prints("No enemy_data found on", self )
		return

	sprite.texture = enemy_data.texture
	initial_position = global_position

	nav_timer.wait_time = randf_range(0, 8)
	nav_timer.start()
	navigation_component.connect("navigating_to_target", _on_navigating_to_target)
	navigation_component.connect("navigation_finished", _on_navigation_finished)

	add_to_group("enemy")


func _on_navigation_timer_timeout() -> void:
	var target: Vector2
	target.x = initial_position.x + randf_range(-50, 50)
	target.y = initial_position.y + randf_range(-50, 50)
	navigation_component.navigate_to_target(target)
	nav_timer.wait_time = randf_range(4, 8)


func _on_navigating_to_target(direction):
	movement_component.move_toward(direction)
	animation_component.play_animation("walk")


func _on_navigation_finished():
	animation_component.play_animation("idle")
