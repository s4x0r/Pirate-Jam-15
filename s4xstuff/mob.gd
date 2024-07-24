extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
var mode = "search"
var minD = 2
var hp = 10
var rDist=5

var move_path: PackedVector3Array

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
func _ready():
	pass

func _physics_process(delta):
	#Delete if health is less then zero
	if hp <=0:
		queue_free()
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	var to = position
	if !move_path.is_empty():
		to = move_path[0]

		var input_dir =  to - position
		#var direction = (transform.basis * Vector3(input_dir.x, 0, -input_dir.y)).normalized()
		var direction = input_dir.normalized()
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED 

			$model.look_at(to_global(Vector3(-velocity.x, 0, -velocity.z)))
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)

		if input_dir.length()<minD:
			#print("reached: ", move_path[0])
			move_path.remove_at(0)
			return
	else:
		velocity.x=0
		velocity.z = 0

		if mode == "search":
			$AnimationPlayer.play("search")
		pass

#		print(	"""pos: %s
#player: %s
#input: %s
#vel: %s
#dist: %s
#path: %s
#	"""%[position, $"../PlayerBase/model".global_position, input_dir, velocity, input_dir.length(), move_path])

		

		


	move_and_slide()

	
func damage(dmg):
	hp -= dmg
	pass 

func attack():
	pass

#THE MISSILE GUIDANCE SUBSYSTEM GENERATES CORRECTIVE COMMANDS
func get_nav_path(tPos):
	var map := get_world_3d().navigation_map # get navigation map
	var target_point := NavigationServer3D.map_get_closest_point(map, tPos) # get the target point

	move_path = NavigationServer3D.map_get_path(map, global_position, target_point, true) # get the movement path
	#print([tPos, target_point, move_path])

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "damaged":
		pass
	
	#IN THE EVENT THAT NO TARGET WAS FOUND
	elif anim_name == "search":
		#THE MISSILE DRIVES ITSELF TO A POSITION IT WASN'T 
		mode = "search"
		#get_nav_path(global_position+Vector3(randf_range(-rDist, rDist),0,randf_range(-rDist, rDist)))
		get_nav_path($"../PlayerBase".global_position)
		pass
	pass # Replace with function body.


func _on_search_space_body_entered(body:Node3D):
	if body.name == "PlayerBase":
		mode = "attack"
		get_nav_path(body.global_position)
		pass

	pass # Replace with function body.
