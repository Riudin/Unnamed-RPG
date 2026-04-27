class_name Projectile
extends Node2D


#signal target_hit()

var context: BattleContext

@export var target_pos: Vector2
@export var speed: float
@export var animation: String
@export var has_particles: bool = false

@onready var animated_sprite: AnimatedSprite2D = %AnimatedSprite2D
@onready var hit_effect_particles: GPUParticles2D = %HitEffectParticles

var damage_dealt: int = 0
var is_crit: bool = false

var target_reached: bool = false # helper to stop processing once target is hit. needed because queue_free waits for particles to finish

func _ready() -> void:
	animated_sprite.play(animation)
	look_at(target_pos)


func _process(delta: float) -> void:
	if target_reached:
		return
		
	var direction := (target_pos - global_position).normalized()
	global_position += direction * speed * delta

	if global_position.distance_to(target_pos) < 10.0:
		_on_hit()


func _on_hit():
	target_reached = true

	if context.defender and context.defender.health_component.has_method("take_damage"):
		context.defender.health_component.take_damage(damage_dealt)

	if context.defender:
		DamagePopupManager.spawn(
			int(damage_dealt),
			context.defender.global_position,
			#DamagePopupManager.damage_colors[damage_source.damage_type],
			Color.WHITE,
			is_crit
			)

	#target_hit.emit()

	if hit_effect_particles and has_particles:
		animated_sprite.hide()
		hit_effect_particles.one_shot = true
		hit_effect_particles.emitting = true
		await get_tree().create_timer(hit_effect_particles.lifetime).timeout
		
	queue_free()
