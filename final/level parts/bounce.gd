extends Area3D
@export var damage = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	for i in get_overlapping_bodies():
		i.damage({"value":damage, "elements":["light"]})
	pass # Replace with function body.
