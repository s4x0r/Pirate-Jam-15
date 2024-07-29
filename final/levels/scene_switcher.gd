extends Node
@onready var loaded = $splash


func switch_to(scene):
	var scn = load(scene).instantiate()
	if loaded != null:
		loaded.queue_free()
	add_child(scn)
	loaded = scn
	pass

func play_bgm(audio):
	$AudioStreamPlayer.playing = false
	$AudioStreamPlayer.stream=(audio)
	$AudioStreamPlayer.playing = true
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_audio_stream_player_finished():
	$AudioStreamPlayer.playing = true
	pass # Replace with function body.
