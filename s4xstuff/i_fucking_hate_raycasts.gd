extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):

	var laser = $CharacterBody3D/RayCast3D
	var mesh = $CharacterBody3D/RayCast3D/bouncemesh
	var bouncemesh = $CharacterBody3D/RayCast3D/pivot
	var pos
	if laser.is_colliding():
		pos = laser.get_collision_point()
	else:
		pos = to_global(laser.target_position)

	var ray_length = laser.global_position.distance_to(pos)

	mesh.mesh.height=ray_length
	mesh.position = Vector3(0,0,-ray_length/2)

	if laser.is_colliding():
		bouncemesh.visible = true
		var b_pos = ((laser.get_collision_point() - laser.global_position)).bounce(laser.get_collision_normal())
		bouncemesh.global_position = pos
		bouncemesh.look_at(b_pos*ray_length)
		bouncemesh.get_node("bouncemesh2").mesh.height = ray_length
		bouncemesh.get_node("bouncemesh2").position = Vector3(0,0,-ray_length/2)

		
	else:
		bouncemesh.visible = false


func _on_mouse(_camera:Node, event:InputEvent, eposition:Vector3, _normal:Vector3, _shape_idx:int):
	if event is InputEventMouseMotion:
		$CharacterBody3D.look_at(eposition*Vector3(1,0,1))
