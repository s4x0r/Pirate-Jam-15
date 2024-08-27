extends Node3D
@export var text_list = ["loreal epson"]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Panel/RichTextLabel.text = text_list[0]
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func interact():
	if !$Panel.visible:
		$Panel.visible=true
		pass


func _input(event: InputEvent) -> void:
	if !$Panel.visible: return
	if event.is_action_pressed("player_primary") || event.is_action_pressed("player_interact"):
			if text_list.size()-text_list.find($Panel/RichTextLabel.text) == 1:
				$Panel.visible = false
				$Panel/RichTextLabel.text = text_list[0]
			else:
				$Panel/RichTextLabel.text = text_list[text_list.find($Panel/RichTextLabel.text) +1]

	pass