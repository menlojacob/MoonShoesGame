extends Node

const SPEED = 110.0
const JUMP_VELOCITY = -300.0
const JUMP_CANCEL_FACTOR = 0.5 #when you do a short jump, it's JUMP_VELOCITY * JUMP_CANCEL_FACTOR

@onready var character = get_parent()
@onready var collisionArea = character.get_node("EnemyCollision")
@onready var lastSafePosition = character.global_position
@onready var sprite: AnimatedSprite2D = $"../Sprite"

var lastJumpedOnEnemyId = 0
var jumping = false # for the jump animation so it doesnt get overwritten
var movementLocked = 0 #if above 0, A and D keys will not influence horizontal movement
var direction = null
var lastValidDirection = 1
var isDoingAction = false #dashing, ground pounding, etc.
var jumpReleased = false

func jump():
	character.velocity.y = JUMP_VELOCITY
	jumping = true
	jumpReleased = false

func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if not isMovementLocked():
		# Add the gravity.
		if not character.is_on_floor():
			character.velocity += character.get_gravity() * delta

		# Handle jump.
		if Input.is_action_just_pressed("jump") and character.is_on_floor():
			jump()
		
		direction = Input.get_axis("move_left", "move_right")
		if direction:
			character.velocity.x = direction * SPEED
			lastValidDirection = direction
		else:
			character.velocity.x = move_toward(character.velocity.x, 0, SPEED)
		
	if character.is_on_floor():
		lastJumpedOnEnemyId = 0
		jumping = false
		
	handle_animations(direction)
	
	if direction == 1:
		sprite.flip_h = true
	elif direction == -1:
		sprite.flip_h = false
		
	#run enemy bounce checks if we're moving downward
	#We could connect to the area2d's body_entered signal for this, but that can be a bit inconsistent
	#since body_entered won't continue to fire unless we exit the body and re-enter it again
	
	var bodies = collisionArea.get_overlapping_bodies()
	for body in bodies:
		#skip our own character
		if body == character:
			continue
		
		var enemyController = body.get_node_or_null("EnemyController")
		if enemyController and enemyController.is_alive():
			var isMovingDownward = character.velocity.y > 0
			var isBelowEnemy = character.global_position.y > body.global_position.y
			
			if (not isMovingDownward) or (isBelowEnemy):
				# get hit
				if body.get_instance_id() != lastJumpedOnEnemyId:
					respawn()
			else:
				if isMovingDownward:
					# bounce
					jumping = false # reset the jump animation
					handle_animations(direction)
					jumping = true
					handle_animations(direction)
					
					if not isMovementLocked():
						jump()
					
					enemyController.jumped_on()
					lastJumpedOnEnemyId = body.get_instance_id()
	
	if (not Input.is_action_pressed("jump")) and (character.velocity.y > -275) and (character.velocity.y < 0) and (not jumpReleased):
		print(character.velocity.y)
		jumpReleased = true
		character.velocity.y *= JUMP_CANCEL_FACTOR
	
	character.move_and_slide()

func respawn():
	character.global_position = GameManager.respawn_point
	character.get_node("CollisionShape2D").set_deferred("disabled", false)
	get_tree().call_group("EnemyController","respawn")
	
func isMovementLocked():
	return movementLocked > 0
	
func lockMovement():
	movementLocked += 1
	
func unlockMovement():
	movementLocked -= 1

func getDirection():
	return direction
	
func getLastValidDirection():
	return lastValidDirection

func getDoingAction():
	return isDoingAction
	
func setDoingAction(doingAction):
	isDoingAction = doingAction

func handle_animations(direction):
	if !jumping:
		if direction != 0:
			sprite.play("walk")
		else:
			sprite.play("idle")
	else:
		sprite.play("jump")
		await sprite.animation_finished
		jumping = false
