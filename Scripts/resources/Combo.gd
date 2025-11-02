extends Resource

class_name Combo

@export var name: String
@export var tags_needed: Array[Tag]
@export var combos_removed: Array[Combo]

@export var effects = [0,0,0,0,0,0,0,0,0,0]

func _to_string() -> String:
	return "Ingredient(%s)" % name
