extends CharacterBody3D
@export var hp = 20
@export var active = false
var elements = ["dark"]
# Called when the node enters the scene tree for the first time.
func _ready():
	if active:
		elements = ["light"]
		$AnimationPlayer.play("on")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func damage(dmg):
	if elements == ["light"]: return
	#print("dmg")

	var cDmg = DamageTypes.calculate_damage(elements, dmg)

	hp-=cDmg
	if hp <= 0:
		$AnimationPlayer.play("on")
		active = true
		elements = ["light"]
	pass

func _on_area_3d_body_entered(body):
	if body.name == "player" && active:
		body.charging = true
	pass # Replace with function body.


func _on_area_3d_body_exited(body):
	if body.name == "player" && active:
		body.charging = false
	pass # Replace with function body.
