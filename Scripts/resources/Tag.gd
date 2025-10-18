extends Resource

class_name Tag

@export var name:  String

func _to_string() -> String:
	return "Tag(%s)" % name
