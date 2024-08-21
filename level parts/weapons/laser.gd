extends Node3D
@export var timeout:float = 0.8
@export var dmg:int = 5
@export var max_ray_dist = 100

var bouncescn = preload ("res://level parts/bounce.tscn")
var bounces = []
var active = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.wait_time=timeout
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if active:
		laser()
	else:
		for i in bounces:
			i.free()
			bounces = []
	pass



func _on_timer_timeout():
	if !active: return

	for i in bounces:
		var bodies = i.get_node("Area3D").get_overlapping_bodies()
		for j in bodies:
			j.damage(dmg)
	$Timer.start()
	pass # Replace with function body.

func activate():
	active = true
	$Timer.start()
	pass

func deactivate():
	active = false
	pass

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
	var origin = global_position
	var end = to_global(Vector3(0,0,-max_ray_dist))
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
		add_child(bounce)
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
