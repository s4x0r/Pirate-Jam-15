extends Node3D
@export var timeout:float = 0.8
@export var damage:int = 5
@export var charge:int = 2
var active = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.wait_time=timeout
	pass # Replace with function body.




func _on_area_3d_body_entered(body:Node3D) -> void:
		#check line of sight
		var space_state = get_world_3d().direct_space_state
		var origin = global_position
		var end = body.global_position
		var query = PhysicsRayQueryParameters3D.create(origin, end, 3)
		query.collide_with_areas = false

		var result = space_state.intersect_ray(query)

		#print(result["collider"])
		if result == {}: return
		elif result["collider"]==body: body.damage(damage)
		else: return





func _on_timer_timeout():
	if !active: return
	if !get_node("../../../..").send_charge(charge): 
		deactivate()
		return

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
