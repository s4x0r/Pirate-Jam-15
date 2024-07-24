extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	for i in get_tree().get_nodes_in_group("mobs"):
		i.tree_exited.connect(check)
	$player.died.connect(player_died)
	pass # Replace with function body.

func check():
	if get_tree().get_first_node_in_group("mobs")==null:
		print("level clear")
		get_tree().change_scene_to_file("res://final/levels/start_screen.tscn")

func player_died():
	print("game over")
	get_tree().change_scene_to_file("res://final/levels/start_screen.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
