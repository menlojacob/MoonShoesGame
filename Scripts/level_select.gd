extends Node2D
@export var level_one: PackedScene
@export var level_two: PackedScene
@export var level_three: PackedScene
@export var level_four: PackedScene
@export var level_five: PackedScene
@onready var level_one_button: Button = $Levels/Level1
@onready var level_two_button: Button = $Levels/Level2
@onready var level_three_button: Button = $Levels/Level3
@onready var level_four_button: Button = $Levels/Level4
@onready var level_five_button: Button = $Levels/Level5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not GameManager.level_one_beat:
		lock_level(level_two_button)
	if not GameManager.level_two_beat:
		lock_level(level_three_button)
	if not GameManager.level_three_beat:
		lock_level(level_four_button)
	if not GameManager.level_four_beat:
		lock_level(level_five_button)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func lock_level(level: Button) -> void:
	level.disabled = true

func _on_level_1_pressed() -> void:
	get_tree().change_scene_to_packed(level_one)


func _on_level_2_pressed() -> void:
	get_tree().change_scene_to_packed(level_two)


func _on_level_3_pressed() -> void:
	get_tree().change_scene_to_packed(level_three)


func _on_level_4_pressed() -> void:
	get_tree().change_scene_to_packed(level_four)


func _on_level_5_pressed() -> void:
	get_tree().change_scene_to_packed(level_five)


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/title_screen.tscn")
