extends CharacterBody2D


@onready var nav_agent: NavigationAgent2D = %NavigationAgent2D
@onready var animation_component: AnimationComponent = %AnimationComponent
@onready var input_component: InputComponent = %InputComponent
@onready var navigation_component: NavigationComponent = %NavigationComponent

@export var movement_speed := 100.0

var follow_mouse := false

func _ready() -> void:
	input_component.connect("wants_move", _on_wants_move)


func _on_wants_move(target):
	prints("want to move to:", target)