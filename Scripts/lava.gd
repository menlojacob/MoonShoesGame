extends Area2D

@onready var shape = self.get_node_or_null("CollisionShape2D")

func _ready():
	#kill players that touch
	self.body_entered.connect(func(body : PhysicsBody2D):
		var characterController = body.get_node_or_null("CharacterController")
		if characterController:
			characterController.respawn()
	)

	#draw orange rectangle over hitbox
	var rect = ColorRect.new()
	rect.color = Color.ORANGE
	self.add_child(rect)
	
	var size = shape.shape.size
	
	rect.global_position = shape.global_position - (size/2)
	rect.size = size
