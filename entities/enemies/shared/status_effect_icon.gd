class_name StatusEffectIcon
extends Control


@onready var texture_rect: TextureRect = %TextureRect
@onready var progress_bar: ProgressBar = %ProgressBar


func setup(instance: StatusEffectInstance) -> void:
	texture_rect.texture = instance.effect.ICON
	progress_bar.max_value = int(instance.effect.duration * TickManager.TICK_RATE)


func update(instance: StatusEffectInstance) -> void:
	progress_bar.value = abs(int(instance.effect.duration * TickManager.TICK_RATE) - instance.remaining_ticks)
