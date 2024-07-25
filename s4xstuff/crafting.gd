extends Control
var protocard= preload("res://s4xstuff/crafting_card.tscn")

var inventory = {
	"flashlight":0,
	"lamp":0,
	"laser":0,
	"beacon":0,
	"metal":10,
	"glass":10,
	"battery":10,
	"bulb":10
}

var recipes ={
	"flashlight": {"metal":1, "glass":1, "battery":1, "bulb":1},
	"lamp":{"metal":2, "glass":1, "battery":1, "bulb":1},
	"laser":{"metal":1, "glass":2, "battery":2, "bulb":3},
	"beacon":{"metal":1, "glass":4, "battery":4, "bulb":2}
}


# Called when the node enters the scene tree for the first time.
func _ready():
	make_cards()
	refresh_menu()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func make_cards():
	for i in recipes.keys():
		var card = protocard.instantiate()
		card.setup(i, recipes[i], self)
		$Panel/GridContainer.add_child(card)
		

		pass

	pass
func refresh_menu():
	for i in inventory.keys():
		var s ="Panel/inventory/"+ i + "/value"
		get_node(s).text=str(inventory[i])

	for j in recipes.keys():
		var t ="Panel/GridContainer/"+ j + "/Button"
		get_node(t).disabled = !check_craftable(j)


func check_craftable(item):
	for i in recipes[item].keys():
		if inventory[i] < recipes[item][i]:
			return false
	return true

func craft(item):
	if !check_craftable(item): return

	for i in recipes[item].keys():
		inventory[i] -= recipes[item][i]

	inventory[item]+=1
	refresh_menu()


	pass
