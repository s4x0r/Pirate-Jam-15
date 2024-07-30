extends Node3D

signal activate
signal deactivate
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_area_3d_area_exited(_area:Area3D):
	if $Area3D.get_overlapping_areas() == []:
		$AnimationPlayer.play("off")	
		emit_signal("deactivate")
	pass # Replace with function body.

func _on_area_3d_area_entered(_area:Area3D):
	if len( $Area3D.get_overlapping_areas())==1 :
		$AnimationPlayer.play("on")	
		emit_signal("activate")

	pass # Replace with function body.
