extends Node3D

@onready var RHand: MeshInstance3D = $ViewMasked/HandNewParent/hand_Imported/Origin/ArmRight/Skeleton3D/HandRight
@onready var block: MeshInstance3D = $ViewMasked/HandNewParent/hand_Imported/Origin/ArmRight/CardPathEnd
@onready var block2: MeshInstance3D = $ViewMasked/HandNewParent/hand_Imported/Origin/ArmRight/CardPathStart

func _ready() -> void:
	RHand.set_layer_mask_value(1,0)
	RHand.set_layer_mask_value(11,1)
	block.visible = false
	block2.visible = false
