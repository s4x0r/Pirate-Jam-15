extends Node3D



func activate():
	$AnimationPlayer.play("open")
	get_node("/root/scene switcher").loaded.get_node("NavigationRegion3D").bake_navigation_mesh()
	pass
func deactivate():
	$AnimationPlayer.play("closed")
	get_node("/root/scene switcher").loaded.get_node("NavigationRegion3D").bake_navigation_mesh()
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


func _on_button_toggle():
	pass # Replace with function body.
