extends Node2D

@onready var button: Button = $Button

# detect button press
func _on_button_pressed() -> void:
	#switch to title screen scene
	get_tree().change_scene_to_file("res://Scenes/game.tscn")
