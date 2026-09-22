extends Node

var DASH_VELOCITY = 300
var DASH_TIME = 0.25

var currentDashTime = 0.0
var currentDashDirection = 0
var touchedGround = true

@onready var character = self.get_parent()
@onready var characterController = character.get_node_or_null("CharacterController")

func dash(initialDelta):
	currentDashTime = initialDelta
	currentDashDirection = characterController.getLastValidDirection()
	characterController.lockMovement()
	characterController.setDoingAction(true)
	characterController.setInvulnerable(true)
	characterController.touchedEnemy.connect(dashJump)
	
	touchedGround = false
	
func stopDash():
	currentDashTime = 0.0
	currentDashDirection = 0
	characterController.unlockMovement()
	characterController.setDoingAction(false)
	characterController.setInvulnerable(false)
	characterController.touchedEnemy.disconnect(dashJump)

func dashJump(enemyBody, enemyController):
	stopDash()
	characterController.jumpOffEnemy(enemyBody, enemyController)

func _ready():
	characterController.jumpedOnEnemy.connect(func():
		touchedGround = true	
	)

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("Dash") and not characterController.getDoingAction() and touchedGround:
		dash(delta)
	
	if currentDashTime > 0:
		currentDashTime += delta
		if currentDashTime <= DASH_TIME:
			character.velocity.x = DASH_VELOCITY * currentDashDirection
			character.velocity.y = 0
		else:
			stopDash()
	
	if character.is_on_floor():
		touchedGround = true
