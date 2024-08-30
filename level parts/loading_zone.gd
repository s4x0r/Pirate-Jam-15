extends Node3D

@export var scene:String = ""
@export var location:String = ""

signal entered

# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass


func _on_area_3d_body_entered(_body:Node3D) -> void:
	#print(_body)
	entered.emit(self)
	pass # Replace with function body.
