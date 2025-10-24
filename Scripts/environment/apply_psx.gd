extends Node3D

@export var psx_blacklist: Array[Node3D]
@export var psx_material: ShaderMaterial
@onready var psx_blacklist_name: Array[String] = []
var psx_instance: ShaderMaterial

func _ready() -> void:
	for i in psx_blacklist:
		psx_blacklist_name.append(i.name)
	
		
	print(psx_blacklist_name)
	for i in get_all_children(self):
		if i is MeshInstance3D:
			psx_instance = psx_material.duplicate()
			for surface in i.get_mesh().get_surface_count():
				
				i.set_surface_override_material(
					surface,
					psx_material
				)
				surface = i.get_mesh().surface_get_material(surface)
				
				
			pass

func get_all_children(node) -> Array:
	var nodes : Array = []

	for N in node.get_children():
		if N.name not in psx_blacklist_name:
			if N.get_child_count() > 0:
				nodes.append(N)
				nodes.append_array(get_all_children(N))
			else:
				nodes.append(N)
	return nodes
