extends Node

const SPEED = 110.0
const JUMP_CANCEL_FACTOR = 0.5 #when you do a short jump, it's JUMP_VELOCITY * JUMP_CANCEL_FACTOR
const JUMP_HEIGHT = 46
const COYOTE_TIME = 0.15 * 1000 #0.15 seconds, the 1000 is for calculation reasons

@onready var character = get_parent()
@onready var collisionArea = character.get_node("EnemyCollision")
@onready var lastSafePosition = character.global_position
@onready var sprite: AnimatedSprite2D = character.get_node("Sprite")
@onready var characterCollision = character.get_node("CollisionShape2D")

var lastJumpedOnEnemyId = 0
var jumping = false # for the jump animation so it doesnt get overwritten
var movementLocked = 0 #if above 0, A and D keys will not influence horizontal movement
var direction = null
var lastValidDirection = 1
var busy = false #dashing, ground pounding, etc.
var jumpReleased = false
var invulnerable = 0
var horizontalSpeedModifier = 1
var gravityModifier = 1
var lastOnGroundTime = 0

signal touchedEnemy
signal jumpedOnEnemy

func jump(height = JUMP_HEIGHT, variableHeight = true):
	#calculate force needed to reach height
	var gravity = (character.get_gravity().y * gravityModifier)
	var impulse = -sqrt(2 * gravity * height)
	character.velocity.y = impulse
	jumping = true
	jumpReleased = not variableHeight
	
	play_jumping_animation()

func jumpOffEnemy(enemyBody, enemyController):
	#we try to make the player bounce to the same height every time
	#regardless of initial height when they hit the enemy.
	var bounceHeight = JUMP_HEIGHT
	var enemyCollisionShape = enemyBody.get_node_or_null("CollisionShape2D")
	if enemyCollisionShape:
		var topOfEnemyHeight = enemyBody.global_position.y - (enemyCollisionShape.shape.size.y/2)
		var bottomOfPlayerHeight = character.global_position.y + (characterCollision.shape.size.y/2)
		var difference = bottomOfPlayerHeight - topOfEnemyHeight
		bounceHeight += difference
	
	if not isMovementLocked():
		jump(bounceHeight, false)
					
	enemyController.jumped_on()
	lastJumpedOnEnemyId = enemyBody.get_instance_id()
	jumpedOnEnemy.emit()

func _physics_process(delta: float) -> void:
	if character.is_on_floor():
		lastJumpedOnEnemyId = 0
		jumping = false
		
		var currentTime = Time.get_ticks_msec()
		lastOnGroundTime = currentTime
	
	if not isMovementLocked():
		# Add the gravity.
		if not character.is_on_floor():
			character.velocity += character.get_gravity() * gravityModifier * delta

		# Handle jump.
		if Input.is_action_just_pressed("jump") and isOnGround() and (not jumping):
			jump()
		
		direction = Input.get_axis("move_left", "move_right")
		if direction:
			character.velocity.x = direction * SPEED * horizontalSpeedModifier
			lastValidDirection = direction
		else:
			character.velocity.x = move_toward(character.velocity.x, 0, SPEED)
		
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
				if (not isInvulnerable()) and body.get_instance_id() != lastJumpedOnEnemyId:
					respawn()
			else:
				if isMovingDownward:
					# bounce
					jumpOffEnemy(body, enemyController)
			
			touchedEnemy.emit(body, enemyController)
	
	if (not Input.is_action_pressed("jump")) and (character.velocity.y > -275) and (character.velocity.y < 0) and (not jumpReleased):
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

func isBusy():
	return busy
	
func setBusy(isBusy):
	busy = isBusy

func setInvulnerable(isInvulnerable : bool):
	if isInvulnerable:
		invulnerable += 1
	else:
		invulnerable -= 1
		
func isInvulnerable():
	return invulnerable > 0

func setHorizontalSpeedModifier(modifier):
	horizontalSpeedModifier = modifier
	
func setGravityModifier(modifier):
	gravityModifier = modifier

func isOnGround():
	return (Time.get_ticks_msec() - lastOnGroundTime) <= COYOTE_TIME

func handle_animations(direction):
	if bouncing:
		sprite.play("bounce")
		await sprite.animation_finished
		bouncing = false
	elif jumping:
		sprite.play("jump")
		await sprite.animation_finished
		jumping = false
	else:
		if direction != 0:
			sprite.play("walk")
		else:
			sprite.play("idle")

func die():
	sprite.play("death")
	await sprite.animation_finished

func play_jumping_animation():
	sprite.play("jump")
