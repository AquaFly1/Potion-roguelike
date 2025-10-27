extends Node3D

var enemies: Array[PackedScene]
@export var possible_interactions: Array[Interaction]
var current_interaction = null
@onready var enemy_parent: Node3D = $enemy_parent

func _ready() -> void:
	current_interaction = possible_interactions.pick_random()
	enemies = current_interaction.enemies

	Game.interaction_started.connect(start_interaction)
	Game.end_turn.connect(end_turn)
	Game.interaction_ended.connect(interaction_ended)
	

func load_enemies(enemie_list):
	Player.start_turn()
	var pos = -0.4
	for i in range(len(enemie_list)):
		var enemy_inst = enemie_list[i].instantiate()
		enemy_parent.add_child(enemy_inst)
		enemy_inst.position.x += pos
		pos += 0.4

func end_turn():
	for enemy in enemy_parent.get_children():
		enemy.start_turn()
	Player.start_turn()

func interaction_ended():
	Game.is_in_combat = false
	Player.xp += Game.xp_end_of_fight
	Game.xp_end_of_fight = 0

func start_interaction():
	load_enemies(enemies)
	Game.is_in_combat = true
	Player.start_turn()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == "Player-nx":
		Game.interaction_started.emit()
		
func _process(_delta: float) -> void:
	if not Game.is_in_combat:
		if enemy_parent.get_children() == []:
			interaction_ended()
