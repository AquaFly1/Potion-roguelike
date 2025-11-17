extends Node

@onready var point: OmniLight3D = $Point
@onready var flame: AnimatedSprite3D = $StaticBody3D/AnimatedSprite3D
@onready var base_energy = point.light_energy
@export var doors: Array[StaticBody3D]
var size_tween: Tween
var active: bool = false
@onready var base_pos = flame.position
var affect_player_light: bool = false
@onready var player_light: OmniLight3D = Player.node.get_child(0)
@onready var player_light_base_energy: float = player_light.light_energy
@onready var base_size = flame.scale


func _ready() -> void:
	#armature.visible = false
	point.set_layer_mask_value(1,1)
	point.set_layer_mask_value(11,1)
	point.light_energy = 0
	flame.scale = Vector3.ZERO
	



func light_candle():
	active = not active
	
	
	if size_tween: size_tween.stop()
	flame.position = base_pos
	flame.rotation = Vector3.ZERO
	size_tween = create_tween().set_parallel()
	size_tween.set_ease(Tween.EASE_OUT)
	size_tween.set_trans(Tween.TRANS_EXPO)
	if active:
		flame.speed_scale = 1
		size_tween.tween_property(flame,"scale",base_size,0.5)
		size_tween.tween_property(point,"light_energy",base_energy,0.5)
	else: 
		flame.speed_scale = 42
		size_tween.tween_interval(0.05)
		size_tween.set_ease(Tween.EASE_IN)
		size_tween.set_trans(Tween.TRANS_SINE)
		size_tween.chain().tween_property(flame,"position",base_pos + Vector3(0.1,0,0),0.07)
		size_tween.chain().tween_property(point,"light_energy",0,0.07)
		size_tween.tween_property(flame,"scale",Vector3.ZERO,0.02)
	for door in doors:
		door.get_child(0).disabled = not door.get_child(0).disabled
	update_player_light()

func update_player_light() -> void:
	if affect_player_light:
		var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
		if active:
			tween.tween_property(player_light,"light_energy",player_light_base_energy,0.25)
		else:
			tween.tween_property(player_light,"light_energy",0,0.25)
		
