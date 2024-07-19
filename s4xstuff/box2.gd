extends StaticBody3D
var count = 0
var label = ["Hello", "How are you", "..."]
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func interact(user):
	print(user)
	$Sprite3D.visible = false
	$Label3D.visible = true
	
	if count <=2:
		$Label3D.text=label[count]
	count+=1
	print(count)
	pass
