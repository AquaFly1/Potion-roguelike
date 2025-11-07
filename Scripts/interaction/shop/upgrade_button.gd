extends ShopButton

@export var combo: Combo

func _ready() -> void:
	icon = combo.icon

func purchase():
	combo.upgrade_combo()
	super()
