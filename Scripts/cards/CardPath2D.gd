extends Node2D

@export var end_segment: bool
var path_pos_3D: Node3D

func _ready() -> void:
	if end_segment:
		(get_node("../../3D Projection/3D View/ViewMasked/3DMasked/hand2")
		.card_path_end_2D_pos
		.connect(on_update_path_pos))
	else:
		(get_node("../../3D Projection/3D View/ViewMasked/3DMasked/hand2")
		.card_path_start_2D_pos
		.connect(on_update_path_pos))


func on_update_path_pos(_pos):
	position = _pos
	
