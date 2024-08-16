extends Node3D
@export var timeout = 0.8

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.wait_time=timeout
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_timer_timeout():
	if visible:
		
	
		$Timer.start()
	pass # Replace with function body.

func activate():
	pass

func deactivate():
	pass

