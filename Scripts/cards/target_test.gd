extends Marker2D
@export var Target_Obj: Marker2D
var Target_Transform

func _process(delta: float) -> void:
	Target_Transform = Target_Obj.global_transform
	transform = transform.interpolate_with(Target_Transform,10*delta)
