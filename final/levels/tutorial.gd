extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	#for i in get_tree().get_nodes_in_group("mobs"):
		#i.tree_exited.connect(check)
	$player.died.connect(player_died)
	$mob.died.connect(trigger.bind($player, "enemy"))
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
	get_parent().switch_to("res://final/levels/tutorial.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("player_forward") && $ui/move.visible:
		$ui/move.visible = false
	if Input.is_action_just_pressed("zoom_out") && $ui/zoom.visible:
		$ui/zoom.visible = false
	
	if Input.is_action_just_pressed("player_jump") && $ui/jump.visible:
		$ui/jump.visible = false

	if (Input.is_action_just_pressed("cam_rot_l") || Input.is_action_just_pressed("cam_rot_r")) && $ui/rotate.visible:
		$ui/rotate.visible = false

	if (Input.is_action_just_pressed("1")||Input.is_action_just_pressed("2")||Input.is_action_just_pressed("3"))&&$ui/tools.visible:
		$ui/tools.visible = false
		$ui/charge.visible = true
	if Input.is_action_just_pressed("player_inventory") && $ui/inventory.visible:
		$ui/inventory.visible = false



func trigger(_body:Node3D, tname:String):
	match tname:
		"zoom":
			$ui/zoom.visible = true
		"jump":
			$ui/jump.visible = true
		"rotate":
			$ui/rotate.visible = true
		"tool":#schism
			$ui/tools.visible = true
		"charge":
			$ui/charge.visible = false
			$ui/recharge.visible = true
		"recharge":
			$ui/recharge.visible = false
			$ui/enemy.visible = true
			$mob.active = true
		"enemy":
			$ui/enemy.visible = false
			$ui/inventory.visible = true


	pass
