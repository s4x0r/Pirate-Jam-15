extends ColorRect


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func setup(item, recipe, connector):
	name = item
	$name.text = item

	for i in recipe.keys():
		match i:
			"cur level": 
				if recipe["cur level"] == len(recipe["metal"]):
					$level.text = "lvl: max"
					$Button.text = "sold out"
					$Button.disabled = true
				else:
					$level.text = "lvl: %s"%(recipe['cur level']+1)
			_:
				var label = Label.new()

				label.text = "%sx %s"%([recipe[i][recipe['cur level']+1], i])
				$reqs/GridContainer.add_child(label)

		pass
	$Button.pressed.connect(connector.craft.bind(item))

	pass
