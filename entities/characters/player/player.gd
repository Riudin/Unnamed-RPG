extends CharacterBody2D


@onready var animation_component: AnimationComponent = %AnimationComponent
@onready var input_component: InputComponent = %InputComponent
@onready var navigation_component: NavigationComponent = %NavigationComponent
@onready var movement_component: MovementComponent = %MovementComponent


func _ready() -> void:
	input_component.connect("movement_input", _on_movement_input)
	navigation_component.connect("movement_direction_defined", _on_movement_direction_defined)


func _on_movement_input(target):
	navigation_component.navigate_to_target(target)


func _on_movement_direction_defined(direction):
	movement_component.move_toward(direction)