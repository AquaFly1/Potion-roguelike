extends Control

@export var pack_position: String
@export var price: int
@onready var position_label: Label = $position
@onready var price_label: Label = $price

func _ready() -> void:
	price_label.text = str(price)
	position_label.text = pack_position
