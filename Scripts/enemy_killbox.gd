extends Area2D

func _ready() -> void:
	body_entered.connect(func(body : PhysicsBody2D):
		var isMovingUpward = body.velocity.y <= 0
		if isMovingUpward and (not get_parent().is_in_hitstun()):
			var characterController = body.get_node_or_null("CharacterController")
			
			if characterController:
				characterController.die()
	)
	
