extends CharacterBody3D



@onready var battery = $ui/HSplitContainer/VSeparator/ProgressBar

@export var items:Array = ["flashlight", "laser", "lamp", "beacon"]
@export var SPEED = 12.0
@export var JUMP_VELOCITY = 15
@export var max_battery = 150
var zoom_max = 50
var zoom_min = 20
var zoom_step = 2

signal died

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _ready():
	battery.max_value = max_battery
	battery.value = max_battery
	$ui/Panel/inventory._ready()
	pass

func _input(event):

	if event is InputEventJoypadMotion:
		var axis = Vector2(Input.get_joy_axis(0,JOY_AXIS_RIGHT_X),Input.get_joy_axis(0,JOY_AXIS_RIGHT_Y)).normalized()*5
		$pivot.look_at(to_global(Vector3(axis.x, 0, axis.y)))


	if event is InputEventMouseMotion:
		var mouse_vec=(get_viewport().get_visible_rect().size/2-get_viewport().get_mouse_position())*-1#.normalized()*5
		#print([mouse_vec, to_global(Vector3(mouse_vec.x, 0, mouse_vec.y))])
		$pivot.look_at(to_global(Vector3(mouse_vec.x, 0, mouse_vec.y)))

func _physics_process(delta):

	if battery.value <= 0:
		died.emit()

	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta


	if not $ui/Panel.visible:
		if Input.is_action_just_pressed("player_primary") && $pivot/hands/l.get_children() != []:
			$pivot/hands/l.get_children()[0].activate()
		if Input.is_action_just_released("player_primary") && $pivot/hands/l.get_children() != []:
			$pivot/hands/l.get_children()[0].deactivate()

		if Input.is_action_just_pressed("player_secondary") && $pivot/hands/r.get_children() != []:
			$pivot/hands/r.get_children()[0].activate()
		if Input.is_action_just_released("player_secondary")&& $pivot/hands/r.get_children() != []:
			$pivot/hands/r.get_children()[0].deactivate()



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
	#Cast Shadow
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(global_position, global_position-Vector3(0,100,0))
	query.collide_with_areas = false

	var result = space_state.intersect_ray(query)
	#print(global_position, result)
	if result == {}:	$pivot/shadow.position = Vector3(0,-100,0)
	else:	$pivot/shadow.global_position = result["position"]

func put_in_hand(object:Node, hand:String):#only accepts "r" or "l" as a hand value

	var s = "pivot/hands/" + hand
	for i in get_node(s).get_children():
		i.free()

	get_node(s).add_child(object)
	object.global_position = get_node(s).global_position

	get_node("ui/HSplitContainer/VSeparator/"+hand+"/TextureRect").texture = load(InventoryTable.items[object.name]["img"])


func send_charge(ammount:int):
	if battery.value > ammount*1.5:
		battery.value -= ammount
		return true
	else: 
		return false



func pickup(item): #{"metal":6, "glass":3}
	print(item)


func damage(dmg):
	$sounds/damaged.play()
	battery.value-=dmg



func _on_pickupspace_body_entered(body:Node3D):
	pickup(body.items)
	body.queue_free()
	pass # Replace with function body.

		
