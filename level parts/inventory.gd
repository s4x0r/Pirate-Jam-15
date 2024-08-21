extends Control

signal change_weapon(weapon:Node, hand:String)

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


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#make weapon buttons
	for i in items.keys():
		var b = $Panel/GridContainer/item.duplicate()
		b.name = i
		$Panel/GridContainer.add_child(b)
		b.get_node("TextureRect").texture = load(items[i]["img"])
		b.visible = true
		b.gui_input.connect(button_event.bind(b))

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func button_event(event:InputEvent, button:Node):
	if event is not InputEventMouseButton: return
	
	match event.button_index:
		0:#unclick
			pass
		1:#left click
			$Panel/leftbox.global_position = button.global_position
			#print(button.name)
			change_weapon.emit(items[button.name]["weapon"].instantiate(), "l")
		2:#right click
			$Panel/rightbox.global_position = button.global_position
			pass
			change_weapon.emit(items[button.name]["weapon"].instantiate(), "r")
		_:#default
			pass
	#print(event, button)
