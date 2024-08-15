extends Node
@onready var loaded = $splash
var levels=["tutorial", "level_1", "level_2"]
var cur_level = 0



func next_level():
	cur_level+=1
	switch_to("res://final/levels/"+levels[cur_level]+".tscn")

func switch_to_level(lvl):
	cur_level+=lvl
	switch_to("res://final/levels/"+levels[cur_level]+".tscn")

func switch_to(scene):
	var scn = load(scene).instantiate()
	#print(loaded, scene, scn)
	if loaded != null:
		loaded.queue_free()
	add_child(scn)
	loaded = scn
	#print(loaded, scene, scn)
	pass

func play_bgm():
	$AudioStreamPlayer.playing = true
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	pass # Replace with function body.


func _on_audio_stream_player_finished():
	$AudioStreamPlayer.playing = true
	pass # Replace with function body.
