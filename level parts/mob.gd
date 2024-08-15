extends CharacterBody3D
var dropscn = preload("res://level parts/drop.tscn")

@export var speed = 9.0
@export var active = true
const JUMP_VELOCITY = 4.5
var mode = "search"
var minD = 3
var hp = 30
var strength = 5
var rDist=20
var elements = ["dark"]

var drops = ["metal","lens","battery","bulb"]

var move_path: PackedVector3Array

signal died

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
func _ready():
	pass

func _physics_process(delta):
	if !active: return

	if hp <= 0:
		emit_signal("died")
		var instance = dropscn.instantiate()

		var random_drop = drops[randi() % drops.size()]

		instance.items = {random_drop:randi_range(1, 5)}
		instance.set_model()
		get_parent().add_child(instance)
		instance.global_position = global_position
		queue_free()


	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	#THE MISSILE KNOWS WHERE IT IS
	var to = position
	if !move_path.is_empty():
		#print(move_path)
		#IT KNOWS THIS BECAUSE IT KNOWS WHERE IT ISN'T
		to = move_path[0]

		#BY SUBTRACTING WHERE IT ISN'T FROM WHERE IT IS
		#IT OBTAINS THE DIFFERENCE, OR DEVIATION
		var input_dir =  to - global_position

		#THE MISSILE GUIDANCE SUBSYSTEM GENERATES CORRECTIVE COMMANDS
		var direction = input_dir.normalized()
		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed 

			#$model.look_at(global_position+Vector3(velocity.x, 0, velocity.z))
			
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
			velocity.z = move_toward(velocity.z, 0, speed)

		#ARRIVING AT ITS TARGET
		if global_position.distance_to(to)<minD:
			
			#print("reached: ", move_path[0])
			move_path.remove_at(0)
			return
		else:
			$model.look_at(Vector3(to.x, global_position.y, to.z))
			
		#print(move_path, global_position, velocity, input_dir.length(), direction)
		#print(global_position.distance_to(move_path[0]), global_position, move_path[0])
	
	#IF THE MISSILE HAS NO TARGET
	else:
		velocity.x=0
		velocity.z = 0

		if mode == "search":
			$AnimationPlayer.play("search")
			$sounds/search.play()
		elif mode == "chase":
			mode = "attack"
			$AnimationPlayer.play("attack")
			#print("reached player last known position")
		elif mode == "attack":
			pass
		pass

	#THAT DRIVE THE MISSILE FROM A POSITION THAT IT WAS TO A POSITION IT SHOULD BE
	move_and_slide()
	
func damage(dmg):
	$sounds/damaged.play()
	hp -= dmg
	$dmgCounter.text=str(dmg)
	$AnimationPlayer.play("damaged")
	pass 

func attack():
	pass

#THE MISSILE GUIDANCE SUBSYSTEM
func get_nav_path(tPos):
	var map := get_world_3d().navigation_map # get navigation map
	var target_point := NavigationServer3D.map_get_closest_point(map, tPos) # get the target point

	move_path = NavigationServer3D.map_get_path(map, global_position, target_point, true) # get the movement path
	#print([tPos, target_point, move_path])

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "default":
		$AnimationPlayer.play("search")
	
	if anim_name == "damaged":

		pass
	
	#IN THE EVENT THAT NO TARGET WAS FOUND
	elif anim_name == "search":
		#THE MISSILE DRIVES ITSELF TO A POSITION IT WASN'T 
		mode = "search"
		get_nav_path(global_position+Vector3(randf_range(-rDist, rDist),0,randf_range(-rDist, rDist)))
		$AnimationPlayer.play("moving")
		#get_nav_path($"../PlayerBase".global_position)
		pass
	elif anim_name == "attack":
		mode= "search"
		$AnimationPlayer.play("search")
		pass
	pass # Replace with function body.


func _on_search_space_body_entered(body:Node3D):
	#print(body)
	if body.name == "player":
		mode = "chase"
		get_nav_path(body.global_position)
		$AnimationPlayer.play("moving")
		pass
		$sounds/path.play()

	pass # Replace with function body.


func _on_search_space_body_exited(body:Node3D):
	if body.name == "player":
		#var t  = (body.global_position-global_position).normalized()*2*global_position.distance_to(body.global_position)
		get_nav_path(body.global_position)
		#print(t)
		mode = "chase"
		#$AnimationPlayer.play("search")
		pass


func _on_attack_space_body_entered(body):
	if body.name == "player":
		$sounds/hit.play()
		body.damage(strength)

	pass # Replace with function body.
