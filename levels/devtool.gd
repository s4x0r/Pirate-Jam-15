extends Control


@onready var loaded = null
var player = preload ("res://final/level parts/playerv2.tscn")
var levels=["tutorial", "level_1", "level_2"]
var cur_level = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	#Sets random seed for this session, only call once at startup
	randomize()
	
	draw_menu("load")


	pass # Replace with function body.

func draw_menu(menu:String):
	match menu:
		"load":
			var dir = DirAccess.open("res://final/levels")
			
			for i in dir.get_files():
				if i.split(".")[1] == "tscn":
					var b = Button.new()
					b.text = i.split(".")[0]
					b.connect("pressed", switch_to.bind("res://final/levels/"+i))
					$menu/right/scenes/ScrollContainer/VBoxContainer.add_child(b)
		_:
			pass



func _input(event):
	if event.is_action_pressed("escape"):
		if loaded == null:	return			
		if $menu.visible:
			$menu.visible = false
			get_tree().paused = false
		else:
			$menu.visible = true
			get_tree().paused = true
		pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func next_level():
	cur_level+=1
	switch_to("res://final/levels/"+levels[cur_level]+".tscn")

func switch_to_level(lvl):
	cur_level+=lvl
	switch_to("res://final/levels/"+levels[cur_level]+".tscn")

func switch_to(scene):
	if $menu.visible:
		$menu.visible = false
		get_tree().paused = false
	var scn = load(scene).instantiate()
	#print(loaded, scene, scn)
	if loaded != null:
		loaded.queue_free()
	scn.process_mode=Node.PROCESS_MODE_PAUSABLE
	add_child(scn)
	loaded = scn
	#print(loaded, scene, scn)
	pass

func play_bgm():
	$AudioStreamPlayer.playing = true
	pass


func _on_audio_stream_player_finished():
	$AudioStreamPlayer.playing = true
	pass # Replace with function body.
