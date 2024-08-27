extends CharacterBody3D

var active = false
@export var rotation_step = 22.5
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func rotate_l():
	rotation_degrees.y+=rotation_step
	pass

func rotate_r():
	rotation_degrees.y-=rotation_step
	pass






