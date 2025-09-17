extends RigidBody3D

	
func _process(delta: float) -> void:
	if Input.is_action_pressed("ui_up"):
		move_and_collide(Vector3(0, 0, -0.01))
