extends Node

@onready var armature: Node3D = $StaticBody3D/candle/Armature
@onready var point: OmniLight3D = $StaticBody3D/candle/Point


func _ready() -> void:
	armature.visible = false
	point.visible = false


func light_candle():
	armature.visible = true
	point.visible = true
