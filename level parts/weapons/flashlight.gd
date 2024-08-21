extends Node3D
@export var timeout:float = 0.8
@export var dmg:int = 5
@export var charge:int = 2
var active = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.wait_time=timeout
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_timer_timeout():
	if !active: return
	if !get_node("../../../..").send_charge(charge): 
		deactivate()
		return

	var bodies = $Area3D.get_overlapping_bodies()
	for i in bodies:
		i.damage(dmg)
	$Timer.start()
	pass # Replace with function body.

func activate():
	if !get_node("../../../..").send_charge(charge): return
	$AnimationPlayer.play("activate")
	active = true
	$Timer.start()
	pass

func deactivate():
	$AnimationPlayer.play("deactivate")
	active = false
	pass
