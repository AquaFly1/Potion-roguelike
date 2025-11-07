extends Button

class_name ShopButton

@export var price: int = 0
@onready var price_label: Label = $Price



func _on_pressed() -> void:
	if Player.gold >= price:
		Player.gold -= price
		purchase()

func purchase():
	queue_free()

func _process(_delta: float) -> void:
	price_label.text = str(price)
