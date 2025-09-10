extends Control

@export var gold_give: int = 5
@onready var button: Button = $Button

func _on_button_pressed() -> void:
	Player.gold += gold_give
	button.queue_free()
