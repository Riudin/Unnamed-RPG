class_name NavigationComponent
extends Node


@export var parent: Node2D

@onready var nav_agent: NavigationAgent2D = %NavigationAgent2D

var navigating := false

signal navigating_to_target(direction)
signal navigation_finished


func _physics_process(_delta: float) -> void:
	if parent == null:
		return

	if not navigating:
		return
	
	if nav_agent.is_navigation_finished():
		emit_signal("navigation_finished")
		navigating = false
		return
	
	var next_pos = nav_agent.get_next_path_position()
	var direction = (next_pos - parent.global_position).normalized()
	emit_signal("navigating_to_target", direction)


func navigate_to_target(target):
	nav_agent.target_position = target
	navigating = true
