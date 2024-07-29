extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in get_tree().get_nodes_in_group("mobs"):
		i.tree_exited.connect(check)
	$player.died.connect(player_died)
	pass # Replace with function body.

func check():
	if get_tree() == null:
		return
	if get_tree().get_first_node_in_group("mobs")==null:
		print("level clear")
		goto_main_menu()

func player_died():
	print("game over")
	$player.queue_free()
	$"ui/game over".visible = true

func goto_main_menu():
	get_parent().switch_to("res://final/levels/start_screen.tscn")

func reload():
	get_parent().switch_to("res://final/levels/level_1.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
