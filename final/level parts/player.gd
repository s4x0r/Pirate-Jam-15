extends CharacterBody3D

var lamp
var flashlight
var battery
var laser
var laser_end
var charging = false
var elements = ["light"]

const SPEED = 5.0
const JUMP_VELOCITY = 8

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	lamp = $model/Lamp
	flashlight = $model/FlashLight
	battery = $ui/HSplitContainer/VSeparator/ProgressBar
	laser = $model/Laser
	laser_end = $model/Laser/Laser_end

	print($model/FlashLight/Area3D.is_visible_in_tree())
	
func _physics_process(delta):
	
	#print(laser.get_collision_point())
	laser_end.set_global_position((Vector3(laser.get_collision_point().x,0,laser.get_collision_point().z)))
	
	var global_mouse_pos
	global_mouse_pos = $Camera3D.project_position(get_viewport().get_mouse_position(),0)
	
	
	#$Camera3D/RayCast3D.position = get_viewport().get_camera_3d().project_ray_origin(get_viewport().get_mouse_position())
	$Camera3D/RayCast3D.set_global_position(global_mouse_pos)
	$Camera3D/RayCast3D/ray_pos.set_global_position($Camera3D/RayCast3D.get_collision_point())
	#mouse_ray.target_position = $Camera3D.transform
	$model.look_at(Vector3($Camera3D/RayCast3D/ray_pos.get_global_position().x,1,$Camera3D/RayCast3D/ray_pos.get_global_position().z),Vector3.UP,true)
	$model.rotation.x = 0
	$model.rotation.z = 0


	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_just_pressed("player_inventory"):
		$ui.visible = !$ui.visible

	#interact
	if Input.is_action_just_pressed("player_interact") and is_on_floor():
		#print($Area3D.get_overlapping_bodies())
		var bodies = $model/interactSpace.get_overlapping_bodies()
		if bodies != []:
			bodies[0].interact(self)
			pass

	# Handle jump.
	if Input.is_action_just_pressed("player_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("player_left", "player_right", "player_forward", "player_back")
	var new_basis = Basis(Vector3(.707,0,-.707),Vector3(0,1,0), Vector3(.707,0,.707))
	var direction = (new_basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED



	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	
func set_weapon(weapon):
	match weapon:
		"none":
			$model/FlashLight.visible = false
			$model/FlashLight/Area3D.monitoring = false
			
			$model/Lamp.visible = false
			$model/Lamp/Area3D.monitoring = false
			
			$model/Laser.visible = false
			#$model/Laser/Area3D.monitoring = false
		"flashlight":
			$model/FlashLight.visible = !$model/FlashLight.visible
			$model/FlashLight/Area3D.monitoring = !$model/FlashLight/Area3D.monitoring
			
			$model/Lamp.visible = false
			$model/Lamp/Area3D.monitoring = false
			
			$model/Laser.visible = false
			#$model/Laser/Area3D.monitoring = false
			pass
		"laser":
			$model/Laser.visible = !$model/Laser.visible
			#$model/Laser/Area3D.monitoring = !$model/Laser/Area3D.monitoring
			
			$model/Lamp.visible = false
			$model/Lamp/Area3D.monitoring = false
			
			$model/FlashLight.visible = false
			$model/FlashLight/Area3D.monitoring = false
			pass
		"lamp":
			$model/Lamp.visible = !$model/Lamp.visible
			$model/Lamp/Area3D.monitoring = !$model/Lamp/Area3D.monitoring
			
			$model/FlashLight.visible = false
			$model/FlashLight/Area3D.monitoring = false
			
			$model/Laser.visible = false
			#$model/Laser/Area3D.monitoring = false
			pass	

func _input(event):
	if event.is_action_pressed("1") and battery.value >=1:
		set_weapon("flashlight")
		pass

	if event.is_action_pressed("2") and battery.value >=1:
		set_weapon("lamp")

	if event.is_action_pressed("3") and battery.value >=1:
		set_weapon("laser")


func _on_button_pressed():
	print("satisfaction")
	pass # Replace with function body.


func _on_timer_timeout():
	if flashlight.is_visible() == true:
		battery.value = battery.value - 2
	if lamp.is_visible() == true:
		battery.value = battery.value - 4
	if laser.is_visible() == true:
		battery.value = battery.value - 8
	
	if battery.value <=0:
		set_weapon("none")

	if charging == true:
		battery.value = battery.value +5
		
	pass # Replace with function body.


func damage(dmg):

	var cDmg = DamageTypes.calculate_damage("light", dmg)

	battery.value-=cDmg

func body_detected(body):
	#print(body)
	body.damage({"value":5, "types":elements})
	pass
