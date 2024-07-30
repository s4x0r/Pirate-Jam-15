extends Control
var protocard= preload("res://final/level parts/crafting_card.tscn")

var inventory = {
	"metal":10,
	"lens": 10,
	"battery":10,
	"bulb": 10
}

var recipes ={
	"flashlight range": {
		"cur level":0,
		"metal":  [0, 2, 4, 6, 8], 
		"lens":   [0, 1, 2, 3, 4], 
		"battery":[0, 1, 1, 2, 2], 
		"bulb":   [0, 1, 2, 3, 4]
	},
	"flashlight damage": {
		"cur level":0,
		"metal":  [0, 3, 6, 9, 12], 
		"lens":   [0, 2, 3, 4, 5], 
		"battery":[0, 2, 3, 4, 5], 
		"bulb":   [0, 1, 2, 3, 4]
	},
	"flashlight drain": {
		"cur level":0,
		"metal":  [0, 1, 2, 3, 4], 
		"lens":   [0, 1, 1, 1, 2], 
		"battery":[0, 3, 5, 7, 9], 
		"bulb":   [0, 1, 2, 3, 4]
	},
	"lamp range": {
		"cur level":0,
		"metal":  [0, 3, 6, 9, 12], 
		"lens":   [0, 2, 3, 4, 5], 
		"battery":[0, 1, 2, 3, 4], 
		"bulb":   [0, 1, 2, 3, 4]
	},
	"lamp damage": {
		"cur level":0,
		"metal":  [0, 4, 8, 12, 16], 
		"lens":   [0, 3, 4, 5, 6], 
		"battery":[0, 3, 4, 5, 6], 
		"bulb":   [0, 2, 3, 4, 5]
	},
	"lamp drain": {
		"cur level":0,
		"metal":  [0, 2, 4, 6, 8], 
		"lens":   [0, 1, 1, 2, 2], 
		"battery":[0, 4, 6, 8, 10], 
		"bulb":   [0, 2, 3, 4, 5]
	},
	"laser range": {
		"cur level":0,
		"metal":  [0, 4, 8, 12, 16], 
		"lens":   [0, 3, 4, 5, 6], 
		"battery":[0, 2, 3, 4, 5], 
		"bulb":   [0, 1, 2, 3, 4]
	},
	"laser damage": {
		"cur level":0,
		"metal":  [0, 5, 10, 15, 20], 
		"lens":   [0, 4, 5, 6, 7,], 
		"battery":[0, 4, 5, 6, 7], 
		"bulb":   [0, 3, 4, 5, 6]
	},
	"laser drain": {
		"cur level":0,
		"metal":  [0, 3, 6, 9, 12], 
		"lens":   [0, 2, 2, 3, 3], 
		"battery":[0, 5, 7, 9, 11], 
		"bulb":   [0, 3, 4, 5, 6]
	}
}

var upgrades = {
	"flashlight": {
		"damage": [1, 2, 3, 4, 5],
		"drain": [3, 2.5, 2, 1.5, 1],
		"range": [15, 20, 25, 30, 35]
	},
	"lamp": {
		"damage": [2, 4, 6, 8, 10],
		"drain": [4, 3.5, 3, 2.5, 2],
		"range": [20, 25, 30, 35, 40]
	},
	"laser": {
		"damage": [3, 6, 9, 12, 15],
		"drain": [5, 4.5, 4, 3.5, 3],
		"range": [25, 30, 35, 40, 45]
	}
	#"self":{
	#	"speed":[]
	#}
}

# Called when the node enters the scene tree for the first time.
func _ready():
	make_cards()
	refresh_menu()


	pass # Replace with function body.


func make_cards():
	for i in recipes.keys():
		if i == "cur level":
			continue
		else:
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
		
	for k in upgrades.keys():
		for l in upgrades[k].keys():
			var u 
			match l:
				"damage": u = "dmg"
				"drain": u = "drain"
				"range": u = "range"
			
			get_node("Panel/inventory/"+k+"/VBoxContainer/"+l).text = "%s: %s  lvl:%s"%[
				u,
				upgrades[k][l][recipes[k+" "+l]["cur level"]],
				recipes[k+" "+l]["cur level"] 
				]

			

func check_craftable(item):
	for i in recipes[item].keys():
		match i:
			"cur level":
				pass
			_:
				if inventory[i] < recipes[item][i][recipes[item]["cur level"]]:
					return false
	return true

func craft(item):
	if !check_craftable(item): return

	for i in recipes[item].keys():
		match i:
			"cur level": pass
			_:
				inventory[i] -= recipes[item][i][recipes[item]["cur level"]]

	recipes[item]["cur level"]+=1

	var j = item.split(" ") 
	get_parent().get_parent().get_parent().upgrade(item, upgrades[j[0]][j[1]][recipes[item]["cur level"]])
	refresh_menu()


	pass
