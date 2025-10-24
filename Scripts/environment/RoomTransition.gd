extends Area3D
@export var area_other: Area3D
@export var fade_mesh : MeshInstance3D
@export var fade_mesh_other : MeshInstance3D
@onready var parent : Node3D = $".."
@export var zone: CollisionShape3D
var fade_target_value: float = 0
var fading: bool = false
@onready var transition_parent: Node3D = $".."

func _ready() -> void:
	connect("body_entered",on_body_entered)
	connect("body_exited",on_body_exited)
	
func on_body_entered(_body: Node3D) -> void:
	#first half
	if _body == parent.player:
		
		if fade_mesh.transparency != 0:
			fade_mesh_other.transparency = 0
		
			
		else:
			area_other.fading = true
			parent.player.horizontal_velocity = Vector3.ZERO
			parent.player.velocity = Vector3.ZERO
	

func on_body_exited(_body: Node3D) -> void:
	if _body == parent.player:
		if not fading:
			parent.player.dir = Vector3.ZERO
		#print(area_other.global_position.distance_to(parent.player.global_position))
		if area_other.global_position.distance_to(parent.player.global_position) > transition_parent.scale.z:
			
			fade_mesh_other.transparency = 1
	
func _physics_process(_delta: float) -> void:
	if fading:
		
		fade_mesh.transparency = lerp(fade_mesh.transparency,fade_target_value,0.2)
		fade_mesh_other.transparency = 1 - fade_mesh.transparency
		if abs(fade_mesh.transparency-fade_target_value) < 0.05:
			fade_mesh.transparency = 0
			fade_mesh_other.transparency = 1
			fading = false
