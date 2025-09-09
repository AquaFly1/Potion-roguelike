extends Resource

class_name Combo

@export var name: String
@export var tags_needed: Array[Tag]
@export var combos_removed: Array[Combo]

@export var dmg: int = 0
@export var burn: int
@export var poison: int
@export var rejuv: int
@export var heal: int

func _to_string() -> String:
	return "Ingredient(%s)" % name
