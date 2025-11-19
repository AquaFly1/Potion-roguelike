extends Camera3D

func _process(_delta: float) -> void:
	print($"../..".global_position)
	global_transform = Player.node.camera.global_transform
	$"../Parent".global_transform = $"../..".global_transform
