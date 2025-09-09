extends Resource

class_name Ingredient

@export var name: String
@export var tags: Array[Tag]
@export var sprite: Texture2D

func _to_string() -> String:
	return "Ingredient(%s)" % name
