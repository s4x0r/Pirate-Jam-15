extends Control



signal change_weapon(weapon:Node, hand:String)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	pass # Replace with function body.


func make_weapon_buttons():
	for i in $Panel/GridContainer.get_children():
		if i != $Panel/GridContainer/item:
			i.free()

	#make weapon buttons
	
	#for i in get_node("../../..").items:
	for i in get_tree().get_nodes_in_group("player")[0].items:
		var b = $Panel/GridContainer/item.duplicate()
		b.name = i
		$Panel/GridContainer.add_child(b)
		b.get_node("TextureRect").texture = load(InventoryTable.items[i]["img"])
		b.visible = true
		b.gui_input.connect(button_event.bind(b))



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
			change_weapon.emit(InventoryTable.items[button.name]["weapon"].instantiate(), "l")
		2:#right click
			$Panel/rightbox.global_position = button.global_position
			pass
			change_weapon.emit(InventoryTable.items[button.name]["weapon"].instantiate(), "r")
		_:#default
			pass
	#print(event, button)
