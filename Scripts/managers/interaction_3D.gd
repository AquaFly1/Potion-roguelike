extends Node3D

var enemies: Array[PackedScene]
@export var possible_interactions: Array[Interaction]
var current_interaction = null
@onready var enemy_parent = $enemy_parent/SubViewport/Parent

func _ready() -> void:
	current_interaction = possible_interactions.pick_random()
	enemies = current_interaction.enemies

	#Game.interaction_started.connect(start_interaction)
	#Game.turn_ended.connect(turn_ended)
	#Game.interaction_ended.connect(interaction_ended)
	

func load_enemies(enemie_list):
	#Player.start_turn()
	var pos = -0.5*(len(enemie_list)-1)
	for i in range(len(enemie_list)):
		var enemy_inst = enemie_list[i].instantiate()
		enemy_parent.add_child(enemy_inst)
		Game.enemy_list.append(enemy_inst)
		enemy_inst.position.x += pos
		pos += 1

#func turn_ended():
	#for enemy in Game.enemy_list:
		#enemy.start_turn()
	#Player.start_turn()

#func interaction_ended():
	#
	#Player.xp += Game.xp_end_of_fight
	#Game.xp_end_of_fight = 0

#func start_interaction():
	#
	#Game.interaction_started.emit()
	#Player.start_turn()
	#
	#Game.enemies_loaded.emit()

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body == Player.node:
		load_enemies(enemies)
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		Game.interaction_started.emit()
		
#func _process(_delta: float) -> void:
	#if not Game.is_in_combat:
		#if enemy_parent.get_children() == []:
			#interaction_ended()
