extends Node2D
@export var completion_flag: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_level_complete_body_entered(body: Node2D) -> void:
	GameManager.set(completion_flag, true)
	print("hello")
	get_tree().change_scene_to_file("res://Scenes/level_select.tscn")
