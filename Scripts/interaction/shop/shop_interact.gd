extends Area3D

@onready var shop: Control = $Shop

func _on_body_entered(body: Node3D) -> void:
	if body == Player.node:
		shop.visible = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
