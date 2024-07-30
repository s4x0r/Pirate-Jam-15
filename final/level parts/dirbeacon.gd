extends StaticBody3D
var hp = 20
var active = false
var elements = ["dark"]

var bouncescn = preload ("res://final/level parts/bounce.tscn")
var bounces = []
var points =[]
var max_ray_dist =1000
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func damage(dmg):
	if elements == ["light"]: return
	print("dmg")

	var cDmg = DamageTypes.calculate_damage(elements, dmg)

	hp -= cDmg
	if hp <= 0:
		$AnimationPlayer.play("on")
		active = true
		elements = ["light"]
	pass

func rotate_l():
	$pivot.rotation_degrees.y += 15
	pass

func rotate_r():
	$pivot.rotation_degrees.y -= 15
	pass

func activate():
	$pivot/laser.visible = true
	#$pivot/laser/beam.monitoring = true
	$AnimationPlayer.play("on")
	laser()

func deactivate():
	$pivot/laser.visible = false
	#$pivot/laser/beam.monitoring = false
	$AnimationPlayer.play("off")
	for i in bounces:
		i.free()

	bounces = []

func toggle():
	if $pivot/laser.visible:	deactivate()
	else:	activate()


func look_at_activator(target):
	$piot.look_at(Vector3(target.x, global_position.y, target.z))

func laser():
	for i in bounces:
		i.free()

	bounces = []
	#print(bounces)
	#position ray at 0
	#cast ray
	#draw ray
	#if collide reflect
		#loop again
	#else return

	var space_state = get_world_3d().direct_space_state
	var origin = $pivot/laser.global_position
	var end = $pivot/laser.to_global(Vector3(0,0,-max_ray_dist))
	var query = PhysicsRayQueryParameters3D.create(origin, end, 65)
	query.collide_with_areas = false

	var result = space_state.intersect_ray(query)
	var ray_length
	var pos
	#print(result["collider"])
	if result == {}:
		ray_length = max_ray_dist
		pos = end

	elif result["collider"] != null:
		ray_length= origin.distance_to(result["position"])
		pos=result["position"]


	while true:
		#print(result["collider"],result["normal"])
		var bounce = bouncescn.instantiate()
		$pivot.add_child(bounce)
		bounces.append(bounce)
		bounce.get_node("bouncemesh").mesh = bounce.get_node("bouncemesh").mesh.duplicate()
		bounce.get_node("bounceshape").shape = bounce.get_node("bounceshape").shape.duplicate()

		bounce.get_node("bouncemesh").mesh.height = ray_length 
		bounce.get_node("bounceshape").shape.height = ray_length 

		bounce.global_position = origin
		bounce.look_at(end)
		#bounce.position = Vector3(0,0,-ray_length/2)
		bounce.get_node("bouncemesh").position = Vector3(0, 0,  -ray_length / 2)
		bounce.get_node("bounceshape").position = Vector3(0, 0,  -ray_length / 2)

		
		
		if result != {} && result["collider"].collision_layer & 64:

			end = ((pos - origin)).bounce(result["normal"]).normalized()*max_ray_dist
			origin = result["position"]
			#print(origin, end)
			query = PhysicsRayQueryParameters3D.create(origin, end, 65)
			query.collide_with_areas = false

			result = space_state.intersect_ray(query)
			if result["collider"] != null:
				ray_length= origin.distance_to(result["position"])
				pos=result["position"]
			else:
				ray_length = max_ray_dist
				pos = end

			continue
		
		break


		pass
	
	pass
