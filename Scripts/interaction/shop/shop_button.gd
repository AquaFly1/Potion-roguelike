extends Button

class_name ShopButton

@export var price: int = 0:
	set(value):
		price = value
		if price_label: price_label.text = str(value)
@onready var price_label: Label = $Price



func _on_pressed() -> void:
	if Player.gold >= price:
		Player.gold -= price
		purchase()

func purchase():
	queue_free()
