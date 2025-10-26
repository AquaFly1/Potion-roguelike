extends Node

@onready var armature: Node3D = $Armature
@onready var point: OmniLight3D = $Point

func _to_string() -> String:
	return "Candle"
