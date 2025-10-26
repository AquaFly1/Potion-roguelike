extends Node

@onready var armature: Node3D = $Armature
@onready var point: OmniLight3D = $Point


func _ready() -> void:
	armature.visible = false
	point.visible = false


func light_candle():
	armature.visible = true
	point.visible = true
