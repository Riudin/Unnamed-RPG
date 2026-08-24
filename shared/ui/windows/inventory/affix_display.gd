extends Control


@onready var description: Label = %Description
@onready var text: Label = %Text


func set_description(new_text: String) -> void:
	description.text = new_text


func set_text(new_text: String) -> void:
	text.text = new_text