extends CharacterBody2D

@onready var character_controller: Node = $CharacterController

func play_dash_animation():
	character_controller.play_dash_animation()
	
