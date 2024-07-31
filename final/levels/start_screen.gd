extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	get_parent().play_bgm()
	pass # Replace with function body.

func _on_play_pressed():
	get_parent().switch_to_level(0)

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
