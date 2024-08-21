extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


var table = {

}

var items = {
	"flashlight":{
		"img":"res://assets/3D/Attachables/Flashlight/flashlighticon.png",
		"weapon": preload("res://level parts/weapons/flashlight.tscn")
	},
	"lamp":{
		"img":"res://assets/3D/Attachables/Lamp/lampicon.png",
		"weapon": preload("res://level parts/weapons/flashlight.tscn")
	},
	"laser":{
		"img":"res://assets/3D/Attachables/Laser/lasericon.png",
		"weapon": preload("res://level parts/weapons/laser.tscn")
		},
	"beacon":{
		"img":"res://assets/3D/Attachables/Beacon/BeaconIcon.png",
		"weapon": preload("res://level parts/weapons/flashlight.tscn")
		}

}