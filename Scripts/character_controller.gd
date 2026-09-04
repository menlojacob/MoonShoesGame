extends Node

const SPEED = 110.0
const JUMP_VELOCITY = -300.0

@onready var character = get_parent()
@onready var collision = character.get_node("CollisionShape2D")

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
		
	# we raycast downwards each frame to look for an enemy - if found, bounce
	var spaceRid = character.get_world_2d().space
	var spaceState = PhysicsServer2D.space_get_direct_state(spaceRid)
	
	var rayFrom = character.global_position
	var rayTo = rayFrom + (Vector2.DOWN * ((collision.shape.size.y/2) + 1))
	
	var raycastParams = PhysicsRayQueryParameters2D.create(rayFrom, rayTo)
	raycastParams.exclude = [character]
	
	var result = spaceState.intersect_ray(raycastParams)
	
	if !result.is_empty():
		if result.collider.is_in_group("Bouncy"):
			character.velocity.y = JUMP_VELOCITY

	character.move_and_slide()
