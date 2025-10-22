extends Button

var ring: Ring

func _process(_delta: float) -> void:
	if ring:
		self.icon = ring.icon

func _on_pressed() -> void:
	Player.rings.append(ring)
	queue_free()
