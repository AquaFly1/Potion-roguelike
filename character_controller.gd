extends CharacterBody3D

@export var walk_speed: float = 5.0
@export var GRAVITY: float = 9.8
@export var mouse_sensitivity: float = 0.001

@onready var pivot: Node3D = $pivot

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		# Yaw on Player
		rotate_y(-event.relative.x * mouse_sensitivity)
		# Pitch on Pivot
		pivot.rotate_x(-event.relative.y * mouse_sensitivity)
		# Clamp pitch to avoid flipping
		pivot.rotation.x = clamp(pivot.rotation.x, deg_to_rad(-75), deg_to_rad(75))
	elif event is InputEventKey and event.pressed and event.keycode == KEY_0:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
func _physics_process(delta):
	var dir: Vector3 = Vector3.ZERO
	var forward = -transform.basis.z   # forward direction of player
	var right   = transform.basis.x    # right direction of player

	if Input.is_action_pressed("forward"):
		dir += forward
	if Input.is_action_pressed("backward"):
		dir -= forward
	if Input.is_action_pressed("left"):
		dir -= right
	if Input.is_action_pressed("right"):
		dir += right

	dir = dir.normalized()

	# Apply horizontal movement
	velocity.x = dir.x * walk_speed
	velocity.z = dir.z * walk_speed

	# Apply gravity
	if not is_on_floor():
		velocity.y -= GRAVITY * delta
	else:
		velocity.y = -0.01

	# Move character
	move_and_slide()
