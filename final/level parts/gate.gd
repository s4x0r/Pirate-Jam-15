extends Node3D



func activate():
	$AnimationPlayer.play("open")
	get_parent().bake_navigation_mesh()
	pass
func deactivate():
	$AnimationPlayer.play("closed")
	get_parent().bake_navigation_mesh()
	pass

func toggle():
	if $bars.visible:
		activate()
	else:
		deactivate()
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
