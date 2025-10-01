extends CharacterBody3D

@export var walk_speed: float = 10.0
@export var acceleration: float = 0.1
@export var acceleration_air_mult: float = 0.5
@export var jump_force: float = 7
@export var GRAVITY: float = 20
@export var mouse_sensitivity: float = 0.001

@onready var pivot: Node3D = $pivot

var horizontal_velocity: Vector3
var vertical_velocity: Vector3


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
	var h_rot = pivot.global_transform.basis.get_euler().y
	if (Input.is_action_pressed("forward")
	|| Input.is_action_pressed("backward") 
	|| Input.is_action_pressed("left") 
	|| Input.is_action_pressed("right")):
			dir = Vector3(Input.get_action_strength("right") 
								- Input.get_action_strength("left"),
								0,
								Input.get_action_strength("backward") 
								- Input.get_action_strength("forward"))
			dir = dir.rotated(Vector3.UP, h_rot).normalized()
			
	
			
	dir = dir.normalized()
	horizontal_velocity = horizontal_velocity.lerp(
		dir.normalized() * walk_speed, 
		acceleration if is_on_floor() else acceleration * acceleration_air_mult)
	velocity.z = horizontal_velocity.z
	
	velocity.x = horizontal_velocity.x


	# Apply gravity and jumpd
	if is_on_floor():
		velocity.y = -0.01
		if Input.is_action_just_pressed("jump"):
			vertical_velocity = Vector3.UP*jump_force
			velocity.y = vertical_velocity.y
	else:
		velocity.y -= GRAVITY * delta
		

	# Move character
	move_and_slide()
