extends Node3D

@export var psx_backlist_suffix: String = "-nx"
@export var psx_material: ShaderMaterial
@export var psx_shaders: Array[Shader]
@onready var psx_blacklist_name: Array[String] = []
@onready var psx_settings = {
	"Vertex Snapping": amount.MEDIUM, 
	"Affine Mapping": 0.25,
	"Dithering": 2,
	"Color Banding" : 2}
var vertex_snapping_values := [1080,144,96,36]
var dither_values := [0.,0.5,1.]
var color_step_values := [100,48,32,24]

enum amount{NONE,LIGHT,MEDIUM,HEAVY}

var psx_instance: ShaderMaterial
var surface_initial

func _ready() -> void:
	await Player.player_ready
	update_setting("Vertex Snapping", amount.MEDIUM)
	
func update() -> void:
	for i in get_all_children(get_tree().get_root()):
		if i is MeshInstance3D:
			
			for surface in i.get_mesh().get_surface_count():
				psx_instance = psx_material.duplicate()
				surface_initial = i.get_mesh().surface_get_material(surface)
				
				if surface_initial is StandardMaterial3D:
					
					psx_instance.set_shader_parameter(
						"texture_albedo",surface_initial.get("albedo_texture") )
					psx_instance.set_shader_parameter(
						"albedo",surface_initial.get("albedo_color") )
					psx_instance.set_shader_parameter(
						"texture_roughness",surface_initial.get("roughness_texture") )
					psx_instance.set_shader_parameter(
						"emission",surface_initial.get("emission") )
					psx_instance.set_shader_parameter(
						"emission_energy",surface_initial.get("emission_energy_multiplier") )
					psx_instance.set_shader_parameter(
						"texture_emission",surface_initial.get("emission_texture") )
					if surface_initial.get("normal_texture"):
						psx_instance.set_shader_parameter(
						"texture_normal",surface_initial.get("normal_texture") )
						
					psx_instance.set_shader_parameter(
						"uv1_scale",surface_initial.get("uv1_scale") )
						
						
					i.set_surface_override_material(
						surface,
						psx_instance
					)
				elif surface_initial.shader in psx_shaders:
					for parameter in ["affine_amount","resolution"]:
						
						surface_initial.set_shader_parameter(
							parameter,
							psx_material.get_shader_parameter(parameter)
							)
			
					
					
					

func get_all_children(node) -> Array:
	var nodes : Array = []
	for N in node.get_children():
			if psx_backlist_suffix not in N.name:
				
				if N.get_child_count() > 0:
					nodes.append(N)
					nodes.append_array(get_all_children(N))
				else:
					nodes.append(N)
		#if N.name not in psx_blacklist_name:
			#if N.get_child_count() > 0:
				#nodes.append(N)
				#nodes.append_array(get_all_children(N))
			#else:
				#nodes.append(N)
	return nodes

func update_setting(option: String, value) -> void:
	psx_settings[option] = value
	
	psx_material.set_shader_parameter("resolution", 
	Vector2.ONE * vertex_snapping_values[psx_settings["Vertex Snapping"]])
	psx_material.set_shader_parameter("affine_amount", 
	psx_settings["Affine Mapping"])
	
	Player.node.get_node("Crunch/PSX").get_material().set_shader_parameter("dither_blend_strength",
	dither_values[ psx_settings["Dithering"]])
	
	Player.node.get_node("Crunch/PSX").get_material().set_shader_parameter("color_steps",
	color_step_values[ psx_settings["Color Banding"]])

	update()
