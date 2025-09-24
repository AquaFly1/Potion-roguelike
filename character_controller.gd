extends CharacterBody3D

var move_dir = Vector2.ZERO

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("backward"):
		move_dir += Vector2.DOWN
	if event.is_action_pressed("forward"):
		move_dir += Vector2.UP
	if event.is_action_pressed("left"):
		move_dir += Vector2.LEFT
	if event.is_action_pressed("right"):
		move_dir += Vector2.RIGHT


func _physics_process(_delta: float) -> void:
	var vel = Vector3(move_dir[0], move_dir[1], 0)
	move_and_collide(vel)
