extends Path2D

@onready var card_path_end: Node2D = $CardPathEnd
@onready var card_path_start: Node2D = $CardPathStart

func _process(_delta: float) -> void:
	curve.set_point_position(0,card_path_start.global_position)
	curve.set_point_position(1,card_path_end.global_position*1.0001)
	#1.0001 cheap fix for non 0 size
