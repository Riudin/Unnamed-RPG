extends Sprite2D


@onready var parent = get_parent()


func _physics_process(_delta: float) -> void:
	if parent.velocity.x < 0:
		flip_h = true
	else:
		flip_h = false
