extends Control

@onready var money: Label = $Panel/Money

func _on_back_pressed() -> void:
	visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(_delta: float) -> void:
	money.text = str(Player.gold)
