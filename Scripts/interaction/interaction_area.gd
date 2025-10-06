extends Area3D
@export var interactions: Array[PackedScene]
@export_file("*.tscn") var pkd_interaction_str: Array[String]

var next_interaction = null

func _ready() -> void:
	pkd_interaction_str = []
	for i in range(len(interactions)):
		pkd_interaction_str.append(interactions[i].resource_path)
	choose_next_interaction()

func choose_next_interaction():
	next_interaction = pkd_interaction_str.pick_random()

func _on_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		if interactions != []:
			call_deferred("change_scene",next_interaction)

func change_scene(scene: String) -> void:
	get_tree().change_scene_to_file(scene)
	choose_next_interaction()
