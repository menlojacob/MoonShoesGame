extends CharacterBody2D

@onready var sprite = $Sprite2D

func jumped_on():
	#this enemy turns red for a second when you jump on it
	sprite.modulate = Color(1,0,0)
	await get_tree().create_timer(0.25).timeout
	sprite.modulate = Color(1,1,1)
