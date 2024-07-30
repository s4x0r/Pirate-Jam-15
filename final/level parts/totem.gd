extends StaticBody3D
@export var hp = 20
@export var active = false
var elements = ["light"]
# Called when the node enters the scene tree for the first time.
func _ready():
	if active:
		$AnimationPlayer.play("on")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print($laserspace.get_overlapping_areas())
	pass



func activate():
	$AnimationPlayer.play("on")
	active = true
	$Timer.start()

func deactivate():
	$AnimationPlayer.play("on")
	active = true
	$Timer.stop()
	
func toggle():
	if active: deactivate()
	else : activate()

func _on_laserspace_area_exited(_area:Area3D):
	#print("the bonesa")
	if $laserspace.get_overlapping_areas() == []:
		$AnimationPlayer.play("off")	
	
	pass # Replace with function body.


func _on_laserspace_area_entered(_area:Area3D):
	#print("bone_pose_changed")
	if len($laserspace.get_overlapping_areas())==1 :
		$AnimationPlayer.play("on")	
	

	pass # Replace with function body.


func _on_timer_timeout():
	for i in $Area3D.get_overlapping_bodies():
		match i.name:
			"player": i.damage({"value":-5, "elements":["light"]})
			_: i.damage({"value":5, "elements":["light"]})
	pass # Replace with function body.
