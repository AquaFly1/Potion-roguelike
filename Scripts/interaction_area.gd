extends Area3D

@export var interactions: Array[PackedScene]

var next_interaction = null

func _ready() -> void:
	choose_next_interaction()

func choose_next_interaction():
	next_interaction = interactions.pick_random().instantiate()

func _on_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		if interactions != []:
			get_tree().change_scene_to_packed(next_interaction)
			choose_next_interaction()
