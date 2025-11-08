extends Node3D

@export var Side1Candle: Node3D
@export var Side2Candle: Node3D

@export var transition_color : Color = Color(0,0,0)
@onready var black : MeshInstance3D = $Black
@onready var decal : Decal = $Decal
@onready var side1 : MeshInstance3D = $Side1Area/Side1
@onready var side2 : MeshInstance3D = $Side2Area/Side2

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
		
		
	
	decal.size = scale
	decal.scale = Vector3.ONE/scale
		#shadow.light_negative = false
		#shadow.light_color = transition_color
