extends Path2D

var end_seg_3d: Node3D
var start_seg_3d: Node3D

@export var camera: Camera3D

func _ready() -> void:
	await Player.player_ready
	end_seg_3d = $"../3D Projection/3D View/ViewMasked/HandNewParent/hand_Imported/Origin/ArmRight/CardPathEnd"
	start_seg_3d = $"../3D Projection/3D View/ViewMasked/HandNewParent/hand_Imported/Origin/ArmRight/CardPathStart"
	
func _physics_process(_delta: float) -> void:

	curve.set_point_position(
		0,
	camera.unproject_position(start_seg_3d.global_position)
	)
	curve.set_point_position(
	1,
	camera.unproject_position(end_seg_3d.global_position)
	)
