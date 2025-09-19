extends RigidBody3D

@export var speed: float = 0.01

var camera_pitch_limit: float = deg_to_rad(80)

var mouse_motion = Vector2.ZERO
var mouse_sensitivity = 0.01
@onready var player: RigidBody3D = $"."
@onready var camera: Camera3D = $Camera3D

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta: float) -> void:
	if Input.is_action_pressed("ui_up"):
		move_and_collide(Vector3(0, 0, -speed))
	if Input.is_action_pressed("ui_left"):
		move_and_collide(Vector3(-speed, 0, 0))
	if Input.is_action_pressed("ui_down"):
		move_and_collide(Vector3(0, 0, speed))
	if Input.is_action_pressed("ui_right"):
		move_and_collide(Vector3(speed, 0, 0))

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		mouse_motion += event.relative

func _physics_process(delta):
	var look_dir = -mouse_motion
	camera.rotate_x(look_dir.y * mouse_sensitivity)
	player.rotation.x = clamp(player.rotation.x, -camera_pitch_limit, camera_pitch_limit)
	player.rotate_y(look_dir.x * mouse_sensitivity)
	mouse_motion = Vector2.ZERO
