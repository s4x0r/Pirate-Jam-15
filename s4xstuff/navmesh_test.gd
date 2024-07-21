extends Node3D

const move_speed := 4.0 # Movement speed of the player

var move_path: PackedVector3Array

@onready var playerBase: Node3D = $PlayerBase
@onready var camera: Camera3D = $Camera3D
	
func _on_click_area_input_event(_camera, event: InputEvent, pos: Vector3, _normal, _shape_idx) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		# when clicked somewhere on the ClickArea, get the position
		
		var map := get_world_3d().navigation_map # get navigation map
		var target_point := NavigationServer3D.map_get_closest_point(map, pos) # get the target point
		
		move_path = NavigationServer3D.map_get_path(map, playerBase.position, target_point, true) # get the movement path

func _physics_process(delta: float) -> void:
	var direction := Vector3()
	var step := delta * move_speed

	if !move_path.is_empty():
		var destination := move_path[0] # destination is the next point in move_path
		direction = destination - playerBase.position # get direction of that point
	
		if step > direction.length():
			step = direction.length()
			move_path.remove_at(0)
		
		var diff = direction.normalized() * step
		playerBase.position += diff # change the position of the player
		
		# the following is, so that the player look in the direction he wents
		if !abs(diff.x) < .001 && !abs(diff.z) < .001: # this is for removing jittering
			var look_at_point := playerBase.position + direction.normalized()
			playerBase.look_at(look_at_point, Vector3.UP)
