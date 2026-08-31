extends Node2D


@export var ownership_line_texture: Texture2D
@export var ownership_line_width: float = 1.0

var ownership_lines: Array[Dictionary] = []


func _draw() -> void:
	for i in range(ownership_lines.size() - 1, -1, -1):
		var line_data = ownership_lines[i]
		var enemy: CombatEnemy = line_data["enemy"]
		var target: Marker2D = line_data["target"]
		var panel: InfoPanel = line_data.get("panel")

		if not is_instance_valid(enemy) or not is_instance_valid(target):
			ownership_lines.remove_at(i)
			continue
		if panel and panel.is_dead:
			ownership_lines.remove_at(i)
			if is_instance_valid(target):
				target.queue_free()
			continue

		var start: Vector2 = enemy.line_anchor.global_position
		var end: Vector2 = target.global_position
		var elbow: Vector2 = Vector2(520.0, start.y)

		_draw_line_segment(start, elbow)
		_draw_line_segment(elbow, end)


func _draw_line_segment(start: Vector2, end: Vector2) -> void:
	var delta: Vector2 = end - start
	var length: float = delta.length()

	if length <= 0.0:
		return

	var angle: float = delta.angle()
	var tex_size: Vector2 = ownership_line_texture.get_size()
	var segment_count: int = int(max(1.0, length / max(1.0, tex_size.x)))

	draw_set_transform(start, angle, Vector2.ONE)
	for i in range(segment_count):
		var x: float = i * tex_size.x
		var rect: Rect2 = Rect2(x, -ownership_line_width * 0.5, tex_size.x, ownership_line_width)
		draw_texture_rect(ownership_line_texture, rect, false)
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
