extends Button

class_name ShopButton

@export var price: int = 0



func _on_pressed() -> void:
	if Player.gold >= price:
		Player.gold -= price
		purchase()

func purchase():
	queue_free()
