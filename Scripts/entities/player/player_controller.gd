# Example GDScript for camera control
extends Node3D # Or your player node

@export var mouse_sensitivity: float = 0.5
@export var vertical_rotation_limit: float = PI/3 # 60 degrees

var mouse_captured: bool = false
var mouse_motion_vector: Vector2 = Vector2.ZERO

func _ready():
	pass
	# Capture mouse on left-click and set the camera to captured mode
	#input_event.connect(_on_input_event) # Assuming input_event is an input action
	# Alternatively, capture on mouse_entered signal of the viewport

func _input(event):
	# Check if the mouse is captured before processing motion\
	if not mouse_captured:
		return

	if event is InputEventMouseMotion:
		# Get the relative movement of the mouse
		mouse_motion_vector += event.relative

func _unhandled_input(event):
	# Handle mouse capture and release
	if event.is_action_pressed("ui_accept"): # Assuming ui_accept is the capture action (e.g., left-click)
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		mouse_captured = true
		mouse_motion_vector = Vector2.ZERO # Reset motion vector on capture
		
	if event.is_action_pressed("ui_cancel"): # Assuming ui_cancel is the release action (e.g., Escape key)
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		mouse_captured = false

func _process(delta):
	if not mouse_captured:
		return

	# Rotate the camera pivot (y-axis) and camera (x-axis)
	rotate_y(-mouse_motion_vector.x * mouse_sensitivity * delta)
	get_node("Camera3D").rotate_x(-mouse_motion_vector.y * mouse_sensitivity * delta)

	# Clamp the vertical rotation
	var camera_node = get_node("Camera3D")
	var current_rotation_x = camera_node.rotation.x
	camera_node.rotation.x = clamp(current_rotation_x, -vertical_rotation_limit, vertical_rotation_limit)

	# Reset the mouse motion vector for the next frame
	mouse_motion_vector = Vector2.ZERO

# Example Input Map Setup
# 1. In Project -> Project Settings -> Input Map:
#    - Add "ui_accept" (e.g., Left Mouse Button)
#    - Add "ui_cancel" (e.g., Escape Key)
