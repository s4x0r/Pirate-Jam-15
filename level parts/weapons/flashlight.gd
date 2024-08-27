extends Node3D
@export var timeout:float = 0.8
@export var damage:int = 5
@export var charge:int = 2
var active = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.wait_time=timeout
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



func damage_enemies():
	var bodies = $Area3D.get_overlapping_bodies()
	for i in bodies:
		#check line of sight
		var space_state = get_world_3d().direct_space_state
		var origin = global_position
		var end = i.global_position
		var query = PhysicsRayQueryParameters3D.create(origin, end, 3)
		query.collide_with_areas = false

		var result = space_state.intersect_ray(query)

		#print(result["collider"])
		if result == {}: return
		elif result["collider"]==i: i.damage(damage)
		else: return



func _on_timer_timeout():
	if !active: return
	if !get_node("../../../..").send_charge(charge): 
		deactivate()
		return

	damage_enemies()
	$Timer.start()
	pass # Replace with function body.

func activate():
	$AnimationPlayer.play("activate")
	active = true
	_on_timer_timeout()
	pass

func deactivate():
	$AnimationPlayer.play("deactivate")
	active = false
	pass
