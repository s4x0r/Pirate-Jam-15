extends Node3D
var main_menu = preload("res://final/levels/start_screen.tscn")

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
	main_menu.instantiate()
	get_tree().root.add_child(main_menu)
	queue_free()

func reload():
	get_tree().reload_current_scene()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
