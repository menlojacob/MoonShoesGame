extends Node

const SPEED = 110.0
const JUMP_VELOCITY = -300.0

@onready var character = get_parent()
@onready var collisionArea = character.get_node("EnemyCollision")
@onready var lastSafePosition = character.global_position
@onready var sprite: AnimatedSprite2D = $"../Sprite"

var lastJumpedOnEnemyId = 0
var jumping = false # for the jump animation so it doesnt get overwritten

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not character.is_on_floor():
		character.velocity += character.get_gravity() * delta
	else:
		jumping = false

	# Handle jump.
	if Input.is_action_just_pressed("jump") and character.is_on_floor():
		character.velocity.y = JUMP_VELOCITY
		jumping = true

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
					character.velocity.y = JUMP_VELOCITY
					enemyController.jumped_on()
					lastJumpedOnEnemyId = body.get_instance_id()
	
	character.move_and_slide()

func respawn():
	character.global_position = GameManager.respawn_point
	character.get_node("CollisionShape2D").set_deferred("disabled", false)
	get_tree().call_group("EnemyController","respawn")
	
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
