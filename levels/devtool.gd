extends Control


@onready var loaded = null
var player = preload ("res://level parts/playerv2.tscn")
var player_instance = null
var levels=["tutorial", "level_1", "level_2"]
var cur_level = 0

var save_data = {
		"items": ["flashlight", "laser", "lamp", "beacon"],
		"max_hp": 150,
		"cur_hp": 150
	}

# Called when the node enters the scene tree for the first time.
func _ready():
	#Sets random seed for this session, only call once at startup
	randomize()
	
	draw_menu("load")

	player_instance = player.instantiate()
	player_instance.visible = false
	player_instance.process_mode = PROCESS_MODE_DISABLED
	add_child(player_instance)



	#var s = JSON.stringify({"foo":"oof","bar":"rab"})
	#var json= JSON.new()
	#print (s)
	#json.parse(s)
	#print(json.data)



	pass # Replace with function body.

func draw_menu(menu:String):
	match menu:
		"load":
			var dir = DirAccess.open("res://levels")
			
			for i in dir.get_files():
				if i.split(".")[1] == "tscn":
					var b = Button.new()
					b.text = i.split(".")[0]
					b.connect("pressed", switch_to.bind("res://levels/"+i))
					$menu/right/scenes/ScrollContainer/VBoxContainer.add_child(b)
		_:
			pass



func _input(event):
	if event.is_action_pressed("escape"):
		toggle_menu()

func toggle_menu():
	if $menu.visible:
		show_menu(false)
	else:
		show_menu(true)


func show_menu(vis:bool):
	if vis:
		$menu.visible = true
		get_tree().paused = true
		$menu.mouse_filter = MOUSE_FILTER_STOP
	else:
		$menu.visible = false
		get_tree().paused = false
		$menu.mouse_filter = MOUSE_FILTER_IGNORE
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func next_level():
	cur_level+=1
	switch_to("res://levels/"+levels[cur_level]+".tscn")

func switch_to_level(lvl):
	cur_level+=lvl
	switch_to("res://levels/"+levels[cur_level]+".tscn")

func switch_to(scene):
	show_menu(false)
	var scn = load(scene).instantiate()
	#print(loaded, scene, scn)
	if loaded != null:
		loaded.queue_free()
	scn.process_mode=Node.PROCESS_MODE_PAUSABLE
	add_child(scn)
	loaded = scn

	player_instance.visible = true
	player_instance.process_mode = PROCESS_MODE_INHERIT
	player_instance.global_position = scn.get_node("NavigationRegion3D/landing zone").global_position
	#print(loaded, scene, scn)
	pass

func play_bgm():
	$AudioStreamPlayer.playing = true
	pass


func _on_audio_stream_player_finished():
	$AudioStreamPlayer.playing = true
	pass # Replace with function body.

func save_game():
	save_data = {
		"items": player_instance.items,
		"max_hp": player_instance.max_battery,
		"cur_hp": player_instance.battery.value
	}
	pass

func load_game():
	player_instance.items = save_data["items"]
	player_instance.max_battery = save_data["max_hp"]
	player_instance.battery.value = save_data["cur_hp"]
	pass


func save_to_file():
	var save_file = FileAccess.open("user://savegame.save", FileAccess.WRITE)

	# JSON provides a static method to serialized JSON string.
	var json_string = JSON.stringify(save_data)

	# Store the save dictionary as a new line in the save file.
	save_file.store_line(json_string)





func load_from_file():
	if not FileAccess.file_exists("user://savegame.save"):
		return # Error! We don't have a save to load.



	# Load the file line by line and process that dictionary to restore
	# the object it represents.
	var save_file = FileAccess.open("user://savegame.save", FileAccess.READ)
	while save_file.get_position() < save_file.get_length():
		var json_string = save_file.get_line()

		# Creates the helper class to interact with JSON
		var json = JSON.new()

		# Check if there is any error while parsing the JSON string, skip in case of failure
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue

		# Get the data from the JSON object
		save_data = json.data

