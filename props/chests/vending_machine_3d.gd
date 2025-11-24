extends Node3D

@onready var input_label: Label3D = $Label3D
var packs = []
@onready var buttons: Node3D = $buttons

var input: String

func _ready() -> void:
	for child in $contents.get_children():
		packs.append(child)

func input_button(_camera: Node, _event: InputEvent, key: String):
	input += key
	update_text()
	

func update_text():
	input_label.text = input
	if len(input) == 3:
		for pack in packs:
			if pack.pack_position == input:
				pack.purchase()
				packs.erase(pack)
				update_money_label()

		input = ""
		input_label.text = input
		
func update_money_label():
	pass
