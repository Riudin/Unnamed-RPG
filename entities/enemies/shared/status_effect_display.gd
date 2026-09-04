extends Control


const STATUS_EFFECT_ICON_SCENE: PackedScene = preload("uid://hnqrmw5lrmgh")

var active_effects: Dictionary[StatusEffectInstance, StatusEffectIcon] = {}
#var active_icons: Array[StatusEffectIcon] = []


#@export var burn_icon: Texture2D
#@export var chill_icon: Texture2D
#@export var freeze_icon: Texture2D
#@export var shock_icon: Texture2D
#@export var bleed_icon: Texture2D
#@export var poison_icon: Texture2D


func _physics_process(_delta: float) -> void:
	pass


func on_effect_applied(instance: StatusEffectInstance) -> void:
	var new_icon := STATUS_EFFECT_ICON_SCENE.instantiate()
	add_child(new_icon)
	new_icon.setup(instance)
	active_effects[instance] = new_icon


func on_effect_updated(instance) -> void:
	if active_effects[instance]:
		active_effects[instance].update(instance)


func on_effect_removed(instance) -> void:
	if active_effects[instance]:
		active_effects[instance].queue_free()
