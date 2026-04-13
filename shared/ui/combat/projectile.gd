class_name Projectile
extends Node2D


@export var target: Vector2
@export var speed: float
@export var animation: String
@export var has_particles: bool = false

@onready var animated_sprite: AnimatedSprite2D = %AnimatedSprite2D
@onready var hit_effect_particles: GPUParticles2D = %HitEffectParticles


func _ready() -> void:
	animated_sprite.play(animation)


func _process(delta: float) -> void:
	look_at(target)
	var direction := (target - global_position).normalized()

	global_position += direction * speed * delta

	if global_position.distance_to(target) < 5.0:
		_on_hit()


func _on_hit():
	if hit_effect_particles and has_particles:
		animated_sprite.hide()
		hit_effect_particles.one_shot = true
		hit_effect_particles.emitting = true
		await get_tree().create_timer(hit_effect_particles.lifetime).timeout
		
	queue_free()
