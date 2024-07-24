extends CharacterBody3D
var hp = 20
var active = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func damage(dmg):
	print("dmg")
	if active: return
	hp-=dmg
	if hp <= 0:
		$AnimationPlayer.play("on")
		active = true
	pass

func _on_area_3d_body_entered(body):
	if body.name == "player":
		body.charging = true
	pass # Replace with function body.


func _on_area_3d_body_exited(body):
	if body.name == "player":
		body.charging = false
	pass # Replace with function body.
