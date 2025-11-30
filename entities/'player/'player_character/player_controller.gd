extends CharacterBody3D



#region variables
@export var walk_speed: float = 10.0
@export var acceleration: float = 0.1
@export var acceleration_air_mult: float = 0.5
@export var jump_force: float = 7
@export var GRAVITY: float = 20
@export var mouse_sensitivity: float = 0.001
@export var camera: Node3D
@export var self_light: OmniLight3D
@export var self_dark_light: OmniLight3D

var interaction_node: Node3D

var dir: Vector3 = Vector3.ZERO
var h_rot: float = 0
@export var pivot: Node3D
var mouse_mode_capture: bool = true

@onready var hand_display: Node2D = $"3D Projection"
@export var hand: Control

var horizontal_velocity: Vector3
var vertical_velocity: Vector3

var anim_y: float = 0
var anim_time: float = 0
#endregion
func _ready() -> void:
	
	Player.node = self
	Game.interaction_ended.connect(end_interaction)
	Game.interaction_started.connect(start_interaction)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	mouse_mode_capture = true
	Player.player_ready.emit()
	
		
	
func _physics_process(delta):
	$Head.disabled = Input.is_action_pressed("fly")
	$Body.disabled = Input.is_action_pressed("fly")
	GRAVITY = 20 * (not Input.is_action_pressed("fly") as int)
	#$test.global_position = pivot.global_position + pivot.global_basis*Vector3.FORWARD
	
	if interaction_node:	
		var rot = pivot.rotation
		pivot.look_at(interaction_node.lookat.global_position)
		
		
		#look_at(interaction_node.lookat.global_position)
		#pivot.look_at(interaction_node.lookat.global_position)
			
		
		pivot.rotation = lerp(rot,pivot.rotation, 0.1)	
		rotation.y += pivot.rotation.y
		pivot.rotation.y = 0
		
		var target_position = interaction_node.player_pos.global_position
		target_position.y = global_position.y
		global_position = lerp(global_position,target_position,0.1)
	
	dir = Vector3.ZERO
	h_rot = pivot.global_transform.basis.get_euler().y
#region horizontal
	if not Game.is_in_combat:
		dir = Vector3(Input.get_action_strength("right") 
									- Input.get_action_strength("left"),
									0,
									Input.get_action_strength("backward") 
									- Input.get_action_strength("forward"))
		camera.rotation.z = lerp(camera.rotation.z,-dir.x/40.0,0.1)
		dir = dir.rotated(Vector3.UP, h_rot).normalized()
				
		
				
		dir = dir.normalized()
	
	
	horizontal_velocity = velocity.lerp(
		dir.normalized() * walk_speed, 
		acceleration if is_on_floor() else acceleration*acceleration_air_mult)
		
	velocity.x = horizontal_velocity.x
	velocity.z = horizontal_velocity.z
		
	if Input.is_action_pressed("fly"):
		velocity = pivot.global_transform.basis * (Vector3(Input.get_action_strength("right") 
									- Input.get_action_strength("left"),
									0,
									Input.get_action_strength("backward") 
									- Input.get_action_strength("forward")) * 25)
		
		
	
		
#endregion

#region vertical
	#gravity and jump
	velocity.y -= GRAVITY * delta
	
	if is_on_floor():
		#velocity.y = 0
		if Input.is_action_pressed("jump"):
			velocity.y = jump_force
			#velocity.y = vertical_velocity.y

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

func start_interaction():
	Game.is_in_combat = true
	hand.visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	interaction_node = Game.interaction_node
	
func end_interaction():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	hand.visible = false
	interaction_node = null
