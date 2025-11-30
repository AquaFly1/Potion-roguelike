extends Camera3D

@onready var pivot = $".."
@onready var battle_cam = $"../Enemy and IgnoreWave/SubViewportContainer/EnemyRender/camera"
@onready var camera_base_env = environment.duplicate_deep()
var tween: Tween

func _ready() -> void:

	Player.change_camera_colors.connect(_update_camera_env)

func _unhandled_input(event: InputEvent) -> void:
	if not Game.is_in_combat:
			if event is InputEventMouseMotion:
				# Yaw on Player
				Player.node.rotate_y(-event.relative.x * Player.node.mouse_sensitivity)
				# Pitch on Pivot
				pivot.rotate_x(-event.relative.y * Player.node.mouse_sensitivity)
				# Clamp pitch to avoid flipping
				pivot.rotation.x = clamp(pivot.rotation.x, deg_to_rad(-85), deg_to_rad(75))
			elif event is InputEventKey and event.pressed and event.keycode == KEY_0 and Player.node.mouse_mode_capture == true:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
				Player.node.mouse_mode_capture = false
			elif event is InputEventKey and event.pressed and event.keycode == KEY_0 and Player.node.mouse_mode_capture == false:
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
				Player.node.mouse_mode_capture = true
				
func _update_camera_env(env: Environment, only_adjustments = true):
	camera_base_env = camera_base_env.duplicate()
	if only_adjustments:
		for i in ["adjustment_brightness","adjustment_saturation","adjustment_contrast"]:
			camera_base_env.set(i,env.get(i))
	else:
		camera_base_env = env
		
	if tween and tween.is_running(): tween.stop()
	
	tween_adjustments(camera_base_env,self)
	tween_adjustments(camera_base_env.duplicate_deep(),battle_cam)
func tween_adjustments(env, camera: Camera3D = self):
	tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD).set_parallel()
	for i in ["adjustment_brightness","adjustment_saturation","adjustment_contrast"]:
		tween.tween_property(camera.environment,i,
			env.get(i)
			,3)
