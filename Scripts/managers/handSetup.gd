extends Node3D

@onready var RHand: MeshInstance3D = $ViewMasked/HandNewParent/hand_Imported/Origin/ArmRight/Skeleton3D/HandRight
@export var blocks: Array[Node3D]

func _ready() -> void:
	RHand.set_layer_mask_value(1,0)
	RHand.set_layer_mask_value(11,1)
	for i in blocks:
		i.visible = false
