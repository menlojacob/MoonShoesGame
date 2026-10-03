extends Node

var isPounding = false

@onready var character = self.get_parent()
@onready var characterController = character.get_node_or_null("CharacterController")

func startPound():
	isPounding = true
	characterController.setBusy(true)
	characterController.setHorizontalSpeedModifier(0.5)
	characterController.setGravityModifier(1.5)
	characterController.setEnemyBounceHeightModifier(1.75)
	characterController.jump(24, false)
	character.play_ground_pound_animation()

func stopPound():
	isPounding = false
	characterController.setBusy(false)
	characterController.setHorizontalSpeedModifier(1)
	characterController.setGravityModifier(1)
	characterController.setEnemyBounceHeightModifier(1)

func stopPoundIfPossible():
	if isPounding:
		stopPound()

func _ready():
	characterController.jumpedOnEnemy.connect(stopPoundIfPossible)
	characterController.died.connect(stopPoundIfPossible) #cancel pound on death

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("ground_pound") and (not characterController.isBusy()) and not (characterController.isOnGround()):
		startPound()
	
	if isPounding and characterController.isOnGround():
		stopPound()
