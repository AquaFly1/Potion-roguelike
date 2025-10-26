extends CharacterBody3D



#region variables
@export var walk_speed: float = 10.0
@export var acceleration: float = 0.1
@export var acceleration_air_mult: float = 0.5
@export var jump_force: float = 7
@export var GRAVITY: float = 20
@export var mouse_sensitivity: float = 0.001
@export var camera: Node3D
@onready var interact_text: Label = $Interact_text
@onready var ray_cast: RayCast3D = $Camera_pivot/RayCast

var dir: Vector3 = Vector3.ZERO
var h_rot: float = 0
@onready var pivot: Node3D = $Camera_pivot
var mouse_mode_capture: bool = true

@onready var hand_display: Node2D = $"3D Projection"

var horizontal_velocity: Vector3
var vertical_velocity: Vector3

var anim_y: float = 0
var anim_time: float = 0
#endregion
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	mouse_mode_capture = true

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		# Yaw on Player
		rotate_y(-event.relative.x * mouse_sensitivity)
		# Pitch on Pivot
		pivot.rotate_x(-event.relative.y * mouse_sensitivity)
		# Clamp pitch to avoid flipping
		pivot.rotation.x = clamp(pivot.rotation.x, deg_to_rad(-75), deg_to_rad(75))
	elif event is InputEventKey and event.pressed and event.keycode == KEY_0 and mouse_mode_capture == true:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		mouse_mode_capture = false
	elif event is InputEventKey and event.pressed and event.keycode == KEY_0 and mouse_mode_capture == false:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		mouse_mode_capture = true
func _physics_process(delta):
	
	print(ray_cast.get_collider())
	
	dir = Vector3.ZERO
	h_rot = pivot.global_transform.basis.get_euler().y
#region horizontal
	#if (Input.is_action_pressed("forward")
	#|| Input.is_action_pressed("backward") 
	#|| Input.is_action_pressed("left") 
	#|| Input.is_action_pressed("right")):
	dir = Vector3(Input.get_action_strength("right") 
								- Input.get_action_strength("left"),
								0,
								Input.get_action_strength("backward") 
								- Input.get_action_strength("forward"))
	camera.rotation.z = lerp(camera.rotation.z,-dir.x/40.0,0.1)
	dir = dir.rotated(Vector3.UP, h_rot).normalized()
			
	
			
	dir = dir.normalized()
	
		
	horizontal_velocity = horizontal_velocity.lerp(
		dir.normalized() * walk_speed, 
		acceleration if is_on_floor() else acceleration * acceleration_air_mult)
	velocity.z = horizontal_velocity.z
	
	velocity.x = horizontal_velocity.x
		
#endregion

#region vertical
	#gravity and jump
	if is_on_floor():
		velocity.y = 0
		if Input.is_action_just_pressed("jump"):
			vertical_velocity = Vector3.UP*jump_force
			velocity.y = vertical_velocity.y
	else:
		velocity.y -= GRAVITY * delta
#endregion
		
#region small anims
	if velocity.distance_to(Vector3.ZERO) > 2 and is_on_floor():
		anim_time += delta
		anim_y = (cos(anim_time*15-PI)+1)*-10

	else:
		if is_on_floor():
			if cos(anim_time*15) < 0.98:
				anim_time += delta
				anim_y = (cos(anim_time*15-PI)+1)*-10
			
			else:
				anim_time = 0
		else:
			anim_y = lerpf(anim_y,0,0.1)	
			anim_time = 0 
		
	hand_display.transform.origin.y = anim_y
#endregion
	# Move character
	move_and_slide()

func ray_cast_collide(candle):
	pass
