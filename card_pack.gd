extends Control

@export var pack_position: String
@export var price: int
@onready var position_label: Label = $position
@onready var price_label: Label = $price

var purchased = false

func _ready() -> void:
	price_label.text = str(price)
	position_label.text = pack_position

func purchase():
	if not purchased and price <= Player.gold:
		
		for child in get_children():
			child.visible = false
		purchased = true
		Player.gold -= price
		
