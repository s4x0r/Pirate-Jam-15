extends CharacterBody3D
var hp = 20
var active = false
var elements = ["dark"]
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func damage(dmg):
	if elements == ["light"]: return
	print("dmg")

	var cDmg = DamageTypes.calculate_damage(elements, dmg)

	hp-=cDmg
	if hp <= 0:
		$AnimationPlayer.play("on")
		active = true
		elements = ["light"]
	pass

func rotate_l():
	rotation_degrees.y+=5
	pass

func rotate_r():
	rotation_degrees.y-=5
	pass






