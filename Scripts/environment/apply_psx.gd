extends Node3D

@export var psx_backlist_suffix: String = "-nx"
@export var psx_material: ShaderMaterial
@onready var psx_blacklist_name: Array[String] = []
var psx_instance: ShaderMaterial
var surface_initial

func _ready() -> void:

	for i in get_all_children(get_parent()):
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
					i.set_surface_override_material(
						surface,
						psx_instance
					)
				elif surface_initial.shader == psx_material.shader:
					for parameter in ["affine_amount","jitter"]:
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
