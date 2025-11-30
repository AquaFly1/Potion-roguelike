extends Node3D

@export var Side1Candle: Node3D
@export var Side2Candle: Node3D
@export var secret_passage: bool = false

@export var transition_color : Color = Color(0,0,0)
@onready var black : MeshInstance3D = $"Black-nx"
@onready var decal : Decal = $"Decal-nx"
@onready var side1 : MeshInstance3D = $"Side1Area-nx/Side1"
@onready var side2 : MeshInstance3D = $"Side2Area-nx/Side2"
@onready var block := $StaticBody3D/block

@export var side_1_interaction: Node3D ##spawns ennemies when touching side 1
@export var show_enemies_1_immediately: bool ##orients and shows the enemies immediately, else only when the player enters the fight spawner hitbox
@export var side_2_interaction: Node3D ##spawns ennemies when touching side 2
@export var show_enemies_2_immediately: bool ##orients and shows the enemies immediately, else only when the player enters the fight spawner hitbox
var player_distance_along_z

var gradient_t : GradientTexture1D
var gradient: Gradient

func _ready() -> void:
	if transition_color != Color(0,0,0):
		black.mesh = black.mesh.duplicate(true)
		black.mesh.surface_get_material(0).albedo_color = transition_color
	
		gradient = Gradient.new()
		gradient.set_color(0,transition_color)
		gradient.set_color(1,transition_color)
		gradient_t = GradientTexture1D.new()
		gradient_t.gradient = gradient
		decal.texture_emission = gradient_t
		
		side1.mesh = side1.mesh.duplicate(true)
		side1.mesh.surface_get_material(0).albedo_color = transition_color
		side2.mesh = side1.mesh.duplicate(true)
		
	if Side1Candle or Side2Candle and not secret_passage:
		block.disabled = false
		
	
	decal.size = scale
	decal.scale = Vector3.ONE/scale
	
		#shadow.light_negative = false
		#shadow.light_color = transition_color
		
func get_player_distance() -> float:
	player_distance_along_z = Player.node.global_position - global_position
	player_distance_along_z = player_distance_along_z.project(global_basis*Vector3.FORWARD).length()*sign(player_distance_along_z.dot(global_basis*Vector3.FORWARD))
	return player_distance_along_z
	

func block_exit(open = false) -> void:
	block.set_deferred("disabled", false)
	if not open:
		while abs(get_player_distance()) < scale.z:
			block.position.z = (-get_player_distance() + sign(get_player_distance())*(0.25 + (block.shape.size.z*global_basis.get_scale().z)/2.))/ global_basis.get_scale().z
			await get_tree().create_timer(0.2).timeout
		block.position.z = 0
	if open:
		if secret_passage or not Side1Candle or (Side1Candle and Side1Candle.active): block.set_deferred("disabled", true)
		if secret_passage or not Side2Candle or (Side2Candle and Side2Candle.active): block.set_deferred("disabled", true)
