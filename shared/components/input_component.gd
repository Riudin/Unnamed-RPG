class_name InputComponent
extends Node2D


var follow_mouse := false

signal movement_input(target)
signal movement_stopped


func _physics_process(_delta):
	# as long as the mouse button is pressed, we want to emit the movement input. TODO: change from signal to variable that player script can use directly
	if follow_mouse:
		emit_signal("movement_input", get_global_mouse_position())


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
		if event.pressed:
			# check if mouseclick was on an area like an enemy
			var space := get_world_2d().direct_space_state

			var query := PhysicsPointQueryParameters2D.new()
			query.position = get_global_mouse_position()
			query.collide_with_areas = true
			query.collide_with_bodies = true

			var result := space.intersect_point(query)

			# return if an area like an enemy was clicked
			for hit in result:
				if hit.collider is Area2D:
					return
			
				# start mouse drag movement if the mouseclick hit nothing specific
			follow_mouse = true
			emit_signal("movement_input", get_global_mouse_position())

		# stop mouse drag movement when button is released
		else:
			follow_mouse = false
			emit_signal("movement_stopped")
