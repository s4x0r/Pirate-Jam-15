extends MeshInstance3D

var spinner = preload("res://assets/Spawnables/Spinner.tscn")
var lamp = preload("res://assets/Spawnables/lamp.tscn")
var spawner_select

# Called when the node enters the scene tree for the first time.
func _onready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if event.is_action_pressed("1"):
		spawner_select = 1
	if event.is_action_pressed("2"):
		spawner_select = 2
		
		
		
	if event.is_action_pressed("player_primary"):
		_spawn(spawner_select)


func  _spawn(selection):
	if selection == 1:
		var spawnable = lamp.instantiate()
		get_tree().get_root().add_child(spawnable)
		spawnable.transform.origin = self.global_position
		print("spawn at ", self.get_parent().get_collision_point())
	if selection == 2:
		var spawnable = spinner.instantiate()
		get_tree().get_root().add_child(spawnable)
		spawnable.transform.origin = self.global_position
		print("spawn at ", self.get_parent().get_collision_point())
	
