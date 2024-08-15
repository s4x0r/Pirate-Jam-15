extends Control


func _on_video_stream_player_finished(e = null):
	if e is InputEventMouseMotion: return
	#get_tree().change_scene_to_file("res://final/levels/start_screen.tscn")
	get_parent().switch_to("res://final/levels/start_screen.tscn")
	pass # Replace with function body.
