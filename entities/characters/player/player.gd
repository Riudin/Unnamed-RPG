extends CharacterBody2D


@onready var animation_component: AnimationComponent = %AnimationComponent
@onready var input_component: InputComponent = %InputComponent
@onready var navigation_component: NavigationComponent = %NavigationComponent
@onready var movement_component: MovementComponent = %MovementComponent
@onready var leveling_component: LevelingComponent = %LevelingComponent
@onready var health_component: HealthComponent = %HealthComponent


func _ready() -> void:
	input_component.connect("movement_input", _on_movement_input)
	navigation_component.connect("navigating_to_target", _on_navigating_to_target)
	navigation_component.connect("navigation_finished", _on_navigation_finished)


func _on_movement_input(target):
	navigation_component.navigate_to_target(target)


func _on_navigating_to_target(direction):
	movement_component.move_toward(direction)
	animation_component.play_animation("walk")


func _on_navigation_finished():
	animation_component.play_animation("idle")