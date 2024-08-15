extends MeshInstance3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.


func _on_area_3d_body_entered(body):
	if body.name == "player":
		body.charging = true
	pass # Replace with function body.


func _on_area_3d_body_exited(body):
	if body.name == "player":
		body.charging = false
	pass # Replace with function body.
