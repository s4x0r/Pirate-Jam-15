extends CharacterBody3D

var lamp
var flashlight
var battery
var laser

var charging = false
var elements = ["light"]

const SPEED = 12.0
const JUMP_VELOCITY = 10

var zoom_max = 50
var zoom_min = 20
var zoom_step = 2

var damage_table = {
	"flashlight":2,
	"lamp":1,
	"laser":4
}

var upgrades = {
	"levels":{
		"flashlight":[0,0,0],
		"lamp":[0,0,0],
		"laser":[0,0,0],
		"self":[0,0,0]

	},
	"flashlight":{
		"damage":1,
		"drain":3,
		"range":10
	},
	"lamp":{
		"damage":2,
		"drain":5,
		"range":10
	},
	"laser":{
		"damage":4,
		"drain":10,
		"range":10
	},
	"self":{
		"speed":0
	}
}

signal died


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	lamp = $pivot/Lamp
	flashlight = $pivot/FlashLight
	battery = $ui/HSplitContainer/VSeparator/ProgressBar
	laser = $pivot/laser

	for i in $ui/Panel/crafting.recipes:
		var j = i.split(" ")
		upgrade(
			i, 
			$ui/Panel/crafting.upgrades[j[0]][j[1]][$ui/Panel/crafting.recipes[i]["cur level"]])

	
func _physics_process(delta):

	if battery.value <= 0:
		emit_signal("died") 

	if $pivot/laser.visible:
		draw_laser()

	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_just_pressed("player_inventory"):
		$ui/Panel.visible = !$ui/Panel.visible

	if Input.is_action_just_released("zoom_in"):	$Camera3D.size -= zoom_step
	if Input.is_action_just_released("zoom_out"): $Camera3D.size += zoom_step
	if $Camera3D.size < zoom_min: $Camera3D.size = zoom_min
	if $Camera3D.size > zoom_max: $Camera3D.size = zoom_max

	if Input.is_action_pressed("cam_rot_l"): rotation_degrees.y+=50*delta
	if Input.is_action_pressed("cam_rot_r"): rotation_degrees.y-=50*delta
	
	#interact
	if Input.is_action_just_pressed("player_interact") and is_on_floor():
		#print($Area3D.get_overlapping_bodies())
		var bodies = $pivot/interactSpace.get_overlapping_areas()
		if bodies != []:
			bodies[0].get_parent().interact()
			pass

	# Handle jump.
	if Input.is_action_just_pressed("player_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("player_left", "player_right", "player_forward", "player_back")

	var direction = (transform.basis*Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED



	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()


func draw_laser():

	var ray = $pivot/laser/ray

	var pos
	if ray.is_colliding():
		pos = ray.get_collision_point()
	else:
		pos = $pivot.to_global(ray.target_position)

	var ray_length = ray.global_position.distance_to(pos)

	$pivot/laser/beam/beammesh.mesh.height=ray_length
	$pivot/laser/beam/beamshape.shape.height=ray_length

	$pivot/laser/beam/beammesh.position=Vector3(0,0,-ray_length/2)
	$pivot/laser/beam/beamshape.position=Vector3(0,0,-ray_length/2)


	if ray.is_colliding():
		$pivot/laser/bounce.visible = true
		var b_pos = ((ray.get_collision_point() - ray.global_position)).bounce(ray.get_collision_normal())
		$pivot/laser/bounce.global_position = pos
		$pivot/laser/bounce.look_at(b_pos*ray_length)
		
		$pivot/laser/bounce/bouncemesh.mesh.height = ray_length
		$pivot/laser/bounce/bounceshape.shape.height= ray_length

		$pivot/laser/bounce/bouncemesh.position = Vector3(0,0,-ray_length/2)
		$pivot/laser/bounce/bounceshape.position = Vector3(0,0,-ray_length/2)
		$pivot/laser/bounce.monitoring=true
		
	else:
		$pivot/laser/bounce.monitoring=false
		$pivot/laser/bounce.visible = false

	#print(global_position, pos, ray.get_collider())

func upgrade(item, value):
	var j =item.split(" ")
	upgrades[j[0]][j[1]]=value
	if j[1] == "range":
		match j[0]:
			"flashlight":
				$pivot/FlashLight/Area3D/MeshInstance3D.mesh.height=value
				$pivot/FlashLight/Area3D/MeshInstance3D.position = Vector3(0, 0.5, -value/2)
				$pivot/FlashLight/Area3D/MeshInstance3D.mesh.top_radius = value/2
				

				$pivot/FlashLight/Area3D/CollisionShape3D.free()

				$pivot/FlashLight/Area3D/MeshInstance3D.create_convex_collision()

				$pivot/FlashLight/Area3D/MeshInstance3D/MeshInstance3D_col/CollisionShape3D.reparent($pivot/FlashLight/Area3D)
				
				$pivot/FlashLight/Area3D/MeshInstance3D/MeshInstance3D_col.call_deferred("free")
				
				$pivot/FlashLight.spot_range=value
			"lamp":
				$pivot/Lamp/Area3D/CollisionShape3D.shape.radius = value
				$pivot/Lamp.omni_range = value
			"laser":
				$pivot/laser/ray.target_position=Vector3(0,0,-value)	


func set_weapon(weapon):
	if battery.value<15:
		weapon = "none"
	else:
		$sounds/switchweapon.play()

	match weapon:
		"none":
			$pivot/FlashLight.visible = false
			$pivot/FlashLight/Area3D.monitoring = false
			
			$pivot/Lamp.visible = false
			$pivot/Lamp/Area3D.monitoring = false
			
			$pivot/laser.visible = false
			$pivot/laser/beam.monitoring = false
		"flashlight":
			$pivot/FlashLight.visible = !$pivot/FlashLight.visible
			$pivot/FlashLight/Area3D.monitoring = !$pivot/FlashLight/Area3D.monitoring
			
			$pivot/Lamp.visible = false
			$pivot/Lamp/Area3D.monitoring = false
			
			$pivot/laser.visible = false
			$pivot/laser/beam.monitoring = false
			pass
		"laser":
			$pivot/laser.visible = !$pivot/laser.visible
			$pivot/laser/beam.monitoring = !$pivot/laser/beam.monitoring
			
			$pivot/Lamp.visible = false
			$pivot/Lamp/Area3D.monitoring = false
			
			$pivot/FlashLight.visible = false
			$pivot/FlashLight/Area3D.monitoring = false
			pass
		"lamp":
			$pivot/Lamp.visible = !$pivot/Lamp.visible
			$pivot/Lamp/Area3D.monitoring = !$pivot/Lamp/Area3D.monitoring
			
			$pivot/FlashLight.visible = false
			$pivot/FlashLight/Area3D.monitoring = false
			
			$pivot/laser.visible = false
			$pivot/laser/beam.monitoring = false
			pass	

func _input(event):
	if event.is_action_pressed("1") and battery.value >=1:
		set_weapon("flashlight")
		pass

	if event.is_action_pressed("2") and battery.value >=1:
		set_weapon("lamp")

	if event.is_action_pressed("3") and battery.value >=1:
		set_weapon("laser")


func _on_timer_timeout():
	if battery.value<15: set_weapon("none")

	var bodies = []
	var weap = ""

	if flashlight.is_visible() == true:
		battery.value = battery.value - upgrades["flashlight"]["drain"]
		bodies = $pivot/FlashLight/Area3D.get_overlapping_bodies()
		weap = "flashlight"

	if lamp.is_visible() == true:
		battery.value = battery.value - upgrades["lamp"]["drain"]
		bodies = $pivot/Lamp/Area3D.get_overlapping_bodies()
		weap = "lamp"

	if laser.is_visible() == true:
		battery.value = battery.value - upgrades["laser"]["drain"]
		bodies = $pivot/laser/beam.get_overlapping_bodies()
		bodies += $pivot/laser/bounce.get_overlapping_bodies()
		weap = "laser"
	
	if charging == true:
		battery.value = battery.value +5
	
	for i in bodies:
		i.damage(upgrades[weap]["damage"])

		
	pass # Replace with function body.

func pickup(items): #{"metal":6, "glass":3}

	for i in items.keys():
		$ui/Panel/crafting.inventory[i]+=items[i]
	$ui/Panel/crafting.refresh_menu()

func damage(dmg):
	$sounds/damaged.play()
	battery.value-=dmg




func _on_mouse(_camera:Node, event:InputEvent, eposition:Vector3, _normal:Vector3, _shape_idx:int):
	if event is InputEventMouseMotion:
		$pivot.look_at(to_global(to_local(eposition)*Vector3(1,0,1)))


func _on_pickupspace_body_entered(body:Node3D):
	pickup(body.items)
	body.queue_free()
	pass # Replace with function body.

		
