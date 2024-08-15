extends Node

var type_chart = {
	"type":{
		"resist":[],
		"weak":[],
		"immune":[]
	},
	"fire":{
		"resist":["rock"],
		"weak":["water"],
		"immune":["electric"]
	},
	"water":{
		"resist":["rock"],
		"weak":["electric"],
		"immune":["fire"]
	},
	"rock":{
		"resist":["electric"],
		"weak":["water"],
		"immune":["fire"]
	},
	"electric":{
		"resist":["fire"],
		"weak":["rock"],
		"immune":["water"]
	},
	"light":{
		"resist":[],
		"weak":[],
		"immune":["light"]
	},
	"dark":{
		"resist":[],
		"weak":[],
		"immune":["dark"]
	}
}


func calculate_damage(rcv_type, damage):

	#var dmg = {
	#	"value":5,
	#	"types":["dark", "fire"]
	#}

	var multiplier = 1.0
	for j in rcv_type:
		for i in damage["types"]:
			if j in type_chart[i]["resist"]: multiplier = multiplier/2
			elif j in type_chart[i]["weak"]: multiplier = multiplier+1
			elif j in type_chart[i]["immune"]: multiplier = -1

	return damage["value"]*multiplier


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
