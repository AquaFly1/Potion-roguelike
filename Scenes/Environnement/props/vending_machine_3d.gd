extends Node3D

@onready var input_label: Label3D = $Label3D
var packs = []
@onready var buttons: Node3D = $buttons

var input: String

func _ready() -> void:
	for child in buttons.get_children():
		packs.append(child)

func input_button(body: RayCast3D, key: String):
	print(body.name)
	if body.name == "InteractRay":
		input += key
		update_text()
		print("raycast")

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
