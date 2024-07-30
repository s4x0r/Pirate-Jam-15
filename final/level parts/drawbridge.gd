extends Node3D
@export var raised = true

# Called when the node enters the scene tree for the first time.
func _ready():
	if raised:
		$AnimationPlayer.play("raise")
	else:
		$AnimationPlayer.play("lower")
	pass # Replace with function body.


func raise():
	$AnimationPlayer.play("raise")

func lower():
	$AnimationPlayer.play("lower")
