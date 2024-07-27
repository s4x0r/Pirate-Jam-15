extends ColorRect


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func setup(item, recipe, connector):
	name = item
	$name.text = item

	for i in recipe.keys():
		var label = Label.new()

		label.text = "%sx %s"%([recipe[i], i])
		$reqs/GridContainer.add_child(label)
		pass
	$Button.pressed.connect(connector.craft.bind(item))

	pass
