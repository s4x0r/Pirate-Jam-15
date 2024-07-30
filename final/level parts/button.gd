extends Node3D



signal toggle
signal activate
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func interact():
		if $AnimationPlayer.is_playing(): return
		$AnimationPlayer.play("on")
		emit_signal("activate")
		emit_signal("toggle")
