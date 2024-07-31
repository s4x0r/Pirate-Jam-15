extends Control


func _on_animation_player_animation_finished(fadeinout):
	#get_tree().change_scene_to_file("res://final/levels/start_screen.tscn")
	get_parent().switch_to("res://final/levels/start_screen.tscn")
	pass # Replace with function body.
