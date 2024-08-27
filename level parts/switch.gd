extends Node3D

var active = false

signal activate
signal deactivate
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func interact():
	if active:
		$AnimationPlayer.play("off")
		emit_signal("deactivate")
		active = false
	else:
		$AnimationPlayer.play("on")
		emit_signal("activate")
		active = true
