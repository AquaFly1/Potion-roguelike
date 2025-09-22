extends Node3D

@onready var CardPathStart3D: Node3D = $CardPathStart
@onready var CardPathEnd3D: Node3D = $CardPathEnd

signal card_path_end_2D_pos(pos: Vector2)
signal card_path_start_2D_pos(pos: Vector2)

func _ready() -> void:
	CardPathStart3D.visible= false
	#CardPathEnd3D.visible= false

func _process(_delta: float) -> void:

	card_path_end_2D_pos.emit(
		get_viewport()
		.get_camera_3d()
		.unproject_position(CardPathEnd3D.global_position)
							)
	card_path_start_2D_pos.emit(
		get_viewport()
		.get_camera_3d()
		.unproject_position(CardPathStart3D.global_position)
							)
