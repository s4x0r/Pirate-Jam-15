extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	#get_parent().play_bgm("res://final/assets/Music/Techie.wav")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_play_pressed():
	get_parent().switch_to("res://final/levels/level_1.tscn")

	pass # Replace with function body.



func _on_credits_pressed():
	$credits.visible = !$credits.visible
	pass # Replace with function body.


func _on_settings_pressed():
	pass # Replace with function body.


func _on_levels_pressed():
	pass # Replace with function body.



func _on_credits_close_pressed():
	$credits.visible = false
	pass # Replace with function body.
