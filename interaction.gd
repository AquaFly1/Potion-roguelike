extends Node3D

var enemies: Array[PackedScene]
@export var possible_interactions: Array[PackedScene]
var current_interaction = null

func _ready() -> void:
	current_interaction = possible_interactions.pick_random()
	enemies = current_interaction.enemies
	
	
	Game.is_in_combat = true
	Game.end_turn.connect(end_turn)
	Game.interaction_ended.connect(interaction_ended)
	Player.start_turn()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func load_enemies(enemie_list):
	Game.interaction_started.emit()
	Player.start_turn()
	var pos = -0.4
	for i in range(len(enemie_list)):
		var enemy_inst = enemie_list[i].instantiate()
		add_child(enemy_inst)
		enemy_inst.position.x += pos
		pos += 0.4

func end_turn():
	pass
func interaction_ended():
	pass

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == "Player-nx":
		load_enemies(enemies)
