extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	print([get_node("/root/scene switcher"), get_node("/root/scene switcher").get_children()])
	pass # Replace with function body.


func _on_area_3d_body_entered(body:Node3D):
	if body.name !="player": return
	$AnimationPlayer.play("beam up")
	pass # Replace with function body.

func _on_animation_player_animation_finished(_anim_name:StringName):
	#print(anim_name)
	get_node("/root/scene switcher").next_level()
	pass # Replace with function body.
