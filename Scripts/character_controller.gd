extends Node

const SPEED = 110.0
const JUMP_VELOCITY = -300.0

@onready var character = get_parent()
@onready var collisionArea = character.get_node("EnemyCollision")
@onready var lastSafePosition = character.global_position

var lastJumpedOnEnemyId = 0

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not character.is_on_floor():
		character.velocity += character.get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and character.is_on_floor():
		character.velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
		
	# Apply direction
	if direction:
		character.velocity.x = direction * SPEED
	else:
		character.velocity.x = move_toward(character.velocity.x, 0, SPEED)
		
	if character.is_on_floor():
		lastJumpedOnEnemyId = 0
		
	#run enemy bounce checks if we're moving downward
	#We could connect to the area2d's body_entered signal for this, but that can be a bit inconsistent
	#since body_entered won't continue to fire unless we exit the body and re-enter it again
	
	var bodies = collisionArea.get_overlapping_bodies()
	for body in bodies:
		#skip our own character
		if body == character:
			continue
		
		var enemyController = body.get_node_or_null("EnemyController")
		if enemyController:
			var isMovingDownward = character.velocity.y > 0
			var isBelowEnemy = character.global_position.y > body.global_position.y
			
			if (not isMovingDownward) or (isBelowEnemy):
				# get hit
				if body.get_instance_id() != lastJumpedOnEnemyId:
					die()
			else:
				if isMovingDownward:
					# bounce
					character.velocity.y = JUMP_VELOCITY
					enemyController.jumped_on()
					lastJumpedOnEnemyId = body.get_instance_id()
	
	character.move_and_slide()

func die():
	character.global_position = lastSafePosition
