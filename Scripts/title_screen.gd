extends Node2D
@onready var splash_screen: Control = $SplashScreen


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	splash_screen.visible = not GameManager.splash_screen_shown


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_splash_screen_fade_out() -> void:
	GameManager.splash_screen_shown = true

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/level_one.tscn")

func _on_credits_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/credits.tscn")

func _on_version_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/version_notes.tscn")
