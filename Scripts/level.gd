extends Node2D
@export var completion_flag: String
@onready var player: CharacterBody2D = $Character

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.respawn_point = $SpawnPoint.global_position
	var killzones: Array = $Killzones.get_children()
	for i in killzones:
		if i is Killzone:
			i.respawn.connect(player.get_node("CharacterController").respawn)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_level_complete_body_entered(body: Node2D) -> void:
	GameManager.set(completion_flag, true)
	print("hello")
	get_tree().change_scene_to_file("res://Scenes/level_select.tscn")
