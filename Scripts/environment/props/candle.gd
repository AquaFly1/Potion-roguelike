extends Node

@onready var armature: Node3D = $StaticBody3D/candle/Armature
@onready var point: OmniLight3D = $StaticBody3D/candle/Point
@onready var animation_player: AnimationPlayer = $StaticBody3D/candle/AnimationPlayer


func _ready() -> void:
	armature.visible = false
	point.visible = false
	#animation_player.autoplay = "0"
	


func light_candle():
	armature.visible = not armature.visible
	point.visible = not point.visible
