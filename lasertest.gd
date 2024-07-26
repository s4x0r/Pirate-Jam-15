extends Node3D


@onready var laserRay = $Laser
@onready var beamSegment = load("res://s4xstuff/laser_beam.tscn")
@onready var laser = load("res://s4xstuff/laser.tscn")
const laserLength = 100
const laserDensity = 1.5
const reflectLayer = 1

var points = []
var splits = []

var truePos = null
var trueRot = null

signal openDoor(door)

#since raycast moves all around, this funciton returns it to the starting location
#starting location and rotation should be changed to change the permanent place of the laser
#do not try to change the rotation or position of the parent Node3D to change the starting point
#and trajectory of the laser. Please use truePos and trueRot
func positions(): 
	laserRay.global_position = truePos
	laserRay.target_position = trueRot


func _ready():
	laserRay.target_position = laserRay.target_position*laserLength
	truePos = laserRay.global_position
	trueRot = laserRay.target_position*laserLength


var reflectTarget = null
func _process(delta):

	points = [laserRay.global_position] #cleans the list of places the laser goes
	while true:
		
		laserRay.force_raycast_update()
		if laserRay.is_colliding(): #check if laser in current trajectory is colliding with anything
			if laserRay.get_collider().collision_layer == reflectLayer && len(points)<4: #checks if object is reflective
				reflect()
			else:
				points.append(laserRay.get_collision_point())
				updateLaserBeam()
				positions()
				break
		else: #if not colliding, it is assumed that it will go on to infinity and beyond. 
			if reflectTarget != null:
				if points[-1] != laserRay.global_position + (reflectTarget*laserLength):
					points.append(laserRay.global_position + (reflectTarget*laserLength))
			else:
				if points[-1] != laserRay.global_position + (laserRay.target_position*laserLength):
					points.append(laserRay.global_position + (laserRay.target_position*laserLength))
			updateLaserBeam()
			positions()
			break

	
func updateLaserBeam(): #connects the points with spheres
	print(points)
	for i in range(0, $Beams.get_child_count()):
		$Beams.get_child(i).queue_free()
	for i in range(0, len(points)-1): 
		#var line = points[i+1] - points[i]
		var ray_length = points[i].distance_to(points[i+1])

		#var direction = (line.normalized())/laserDensity
		#var pos = points[i]

		var instance = beamSegment.instantiate()
		$Beams.add_child(instance)

		instance.global_position = points[i]
		instance.look_at(points[i+1])
		
		instance.get_node("beam").mesh.height = ray_length
		instance.get_node("beam").position=Vector3(0,0,-ray_length/2)





func reflect():
	
	reflectTarget = ((laserRay.get_collision_point() - laserRay.global_position)).bounce(laserRay.get_collision_normal())
	laserRay.look_at(reflectTarget)
	laserRay.global_position = laserRay.get_collision_point()
	
	#laserRay.target_position = reflectTarget*laserLength
	points.append(laserRay.global_position)
	updateLaserBeam()
	#this whole sequence goes like this: laser hits reflective object, move start of 
	#laser to the hit point, logs the laser's current position, aims the laser the way
	#it should based on the bounce function, sees if it hits any reflective surface, 
	#and repeat
