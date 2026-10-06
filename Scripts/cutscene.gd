extends Node2D

@export var nextScene = "level_select.tscn"

func _process(delta):
	if Input.is_action_just_pressed("jump"):
		get_tree().change_scene_to_file("res://Scenes/" + nextScene)
