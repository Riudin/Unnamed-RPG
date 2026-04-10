extends Node


var scenes_folder: String = "res://scenes/"


func change_scene(new_scene: String):
	var path := scenes_folder + new_scene + ".tscn"

	# TODO: maybe save playerdata here
	# await fade_out()
	get_tree().call_deferred("change_scene_to_file", path)
	# await fade_in()
