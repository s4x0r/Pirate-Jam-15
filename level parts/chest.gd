extends Node3D
@export var contents = "flashlight"
var active = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func activate():
	if active: return
	$AnimationPlayer.play("activate")
	get_tree().call_group("player", "pickup", contents)
	pass