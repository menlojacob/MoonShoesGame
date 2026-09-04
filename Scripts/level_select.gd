extends Node2D
@onready var level_one: String = "res://Scenes/level_one.tscn"
@onready var level_two: String = "res://Scenes/level_one.tscn" #placeholder
@onready var level_three: String = "res://Scenes/level_one.tscn" #placeholder
@onready var level_four: String = "res://Scenes/level_one.tscn" #placeholder
@onready var level_five: String = "res://Scenes/level_one.tscn" #placeholder

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass



func _on_level_1_pressed() -> void:
	get_tree().change_scene_to_file(level_one)


func _on_level_2_pressed() -> void:
	get_tree().change_scene_to_file(level_two)


func _on_level_3_pressed() -> void:
	get_tree().change_scene_to_file(level_three)


func _on_level_4_pressed() -> void:
	get_tree().change_scene_to_file(level_four)


func _on_level_5_pressed() -> void:
	get_tree().change_scene_to_file(level_five)
