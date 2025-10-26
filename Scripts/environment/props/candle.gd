extends Node

@onready var armature: Node3D = $StaticBody3D/candle/Armature
@onready var point: OmniLight3D = $StaticBody3D/candle/Point
@onready var animation_player: AnimationPlayer = $StaticBody3D/candle/AnimationPlayer
@onready var base_energy = point.light_energy
var size_tween: Tween
var active: bool = false
@onready var base_pos = armature.position

func _ready() -> void:
	#armature.visible = false
	point.light_energy = 0
	armature.scale = Vector3.ZERO
	animation_player.play("ArmatureAction")
	animation_player.speed_scale = 0.5
	animation_player.get_animation("ArmatureAction").loop_mode = Animation.LOOP_LINEAR
	
	


func light_candle():
	active = not active
	#armature.visible = not armature.visible
	#point.visible = not point.visible
	if size_tween: size_tween.stop()
	armature.position = base_pos
	armature.rotation = Vector3.ZERO
	size_tween = create_tween().set_parallel()
	size_tween.set_ease(Tween.EASE_OUT)
	size_tween.set_trans(Tween.TRANS_EXPO)
	if active:
		size_tween.tween_property(armature,"scale",Vector3.ONE,0.5)
		size_tween.tween_property(point,"light_energy",base_energy,0.5)
	else: 
		size_tween.set_ease(Tween.EASE_IN)
		size_tween.set_trans(Tween.TRANS_SINE)
		size_tween.tween_property(armature,"position",base_pos + Vector3(0.1,0,0),0.05)
		size_tween.tween_property(armature,"rotation",base_pos + Vector3(0,0,-0.2),0.05)
		size_tween.tween_property(point,"light_energy",0,0.05)
		size_tween.chain().tween_property(armature,"scale",Vector3.ZERO,0)
		
	#point.light_energy = armature.scale.x * base_energy
