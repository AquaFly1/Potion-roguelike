extends ShopButton

@export var ring: Ring

func _ready() -> void:
	icon = ring.icon

func purchase():
	Player.rings.append(ring)
	super()
