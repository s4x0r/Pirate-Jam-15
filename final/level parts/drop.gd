extends RigidBody3D

@export var items = {}
# Called when the node enters the scene tree for the first time.



func _ready():
	pass # Replace with function body.

func set_model():
	if items != {}:
		get_node("models/"+items.keys()[0]).visible= true

