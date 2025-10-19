extends Area3D
@export var interactions: Array[PackedScene]
@export_file("*.tscn") var pkd_interaction_str: Array[String]

var next_interaction = null
var inter = null
@export var enemies_num = 3
@onready var enemies_parent: Node3D = $enemies_parent
@export var goblin_scene: PackedScene

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
			var pos = -0.4
			for i in range(enemies_num):
				var enemy_inst = goblin_scene.instantiate()
				enemies_parent.add_child(enemy_inst)
				enemy_inst.position.x += pos
				pos += 0.4
#			call_deferred("change_scene",next_interaction)

func change_scene(scene: String) -> void:
	get_tree().change_scene_to_file(scene)
	choose_next_interaction()
