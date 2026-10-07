extends Area2D

@onready var shape = self.get_node_or_null("CollisionShape2D")

# UNUSED
# lava collision is handled in CharacterController now
#func _ready():
	##kill players that touch
	#self.body_entered.connect(func(body : PhysicsBody2D):
		#var characterController = body.get_node_or_null("CharacterController")
		#if characterController:
			#characterController.respawn()
	#)
