extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 8

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_just_pressed("player_inventory"):
		$ui.visible = !$ui.visible

	#interact
	if Input.is_action_just_pressed("player_interact") and is_on_floor():
		print($Area3D.get_overlapping_bodies())
		var bodies = $Area3D.get_overlapping_bodies()
		if bodies != []:
			bodies[0].interact(self)
			pass

	# Handle jump.
	if Input.is_action_just_pressed("player_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("player_left", "player_right", "player_forward", "player_back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED

		$MeshInstance3D.look_at(to_global(Vector3(-velocity.x, 0, -velocity.z)))
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	



func _on_button_pressed():
	print("satisfaction")
	pass # Replace with function body.
