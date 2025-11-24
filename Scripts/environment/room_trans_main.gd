extends Node3D

@export var Side1Candle: Node3D
@export var Side2Candle: Node3D

@export var transition_color : Color = Color(0,0,0)
@onready var black : MeshInstance3D = $"Black-nx"
@onready var decal : Decal = $"Decal-nx"
@onready var side1 : MeshInstance3D = $"Side1Area-nx/Side1"
@onready var side2 : MeshInstance3D = $"Side2Area-nx/Side2"
@onready var block := $StaticBody3D/block

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
		
	if Side1Candle or Side2Candle:
		block.disabled = false
		
	
	decal.size = scale
	decal.scale = Vector3.ONE/scale
		#shadow.light_negative = false
		#shadow.light_color = transition_color
		
func block_exit(open = false) -> void:
	for i in [side1.get_parent(),side2.get_parent()]:
		if i.get_overlapping_bodies():
			$StaticBody3D/softblock.position = i.position * -1
			
			$StaticBody3D/softblock.set_deferred("disabled", false)
			await i.body_exited
			$StaticBody3D/softblock.set_deferred("disabled", true)
	block.set_deferred("disabled", false)
	if open:
		if not Side1Candle or (Side1Candle and Side1Candle.active): block.set_deferred("disabled", true)
		if not Side2Candle or (Side2Candle and Side2Candle.active): block.set_deferred("disabled", true)
