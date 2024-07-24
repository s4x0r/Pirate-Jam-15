extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_static_body_3d_tree_exited():
	get_parent().bake_navigation_mesh()
	queue_free()
	pass # Replace with function body.

func open():
	$StaticBody3D.queue_free()
	
