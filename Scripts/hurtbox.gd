extends Area2D

func _ready() -> void:
	body_entered.connect(func(body: PhysicsBody2D):
		var characterController = body.get_node_or_null("CharacterController")
		if characterController:
			characterController.die()
	)
	
