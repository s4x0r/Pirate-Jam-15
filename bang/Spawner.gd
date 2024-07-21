extends MeshInstance3D

var spinner

# Called when the node enters the scene tree for the first time.
func _onready():
	spinner = preload("res://assets/Spawnables/Spinner.tscn")
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if event.is_action_pressed("player_primary"):
		var spawnable = spinner.instantiate()
		spawnable.set_child($Towers)
		spawnable.set_posistion = self.global_position

