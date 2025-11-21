extends Node3D

var enemies: Array[PackedScene]
@export var possible_interactions: Array[Interaction]
var current_interaction = null

@export_group("Environnement")
@export var sides: int = 2
@export var Exits: Array[Node3D]
@export var enemy_separation: float

@onready var enemy_parent:= $enemy_parent
@onready var lookat:= $enemy_parent/LookAt
@onready var start_angle := rotation
var cleared: bool = false

func _ready() -> void:
	pass

func on_spawn_enemies_enter(_body: Node3D) -> void:

	look_at(_body.global_position)
	#await get_tree().create_timer(0).timeout
	
	
	rotation.y = fmod(rotation.y,PI/2) + PI
	rotation.y = start_angle.y + (rotation-start_angle).snappedf(2*PI/sides).y
	for i in Exits:
		i.block_exit()
	
	
	
		
	load_enemies()
	
	
	await Game.interaction_ended
	
	for i in Exits:
		i.block_exit(true)
	
	
func on_start_fight_entered(_body: Node3D) -> void:
	if not cleared and not Game.is_in_combat:
		Game.interaction_node = self
		Game.interaction_started.emit()

func load_enemies():
	current_interaction = possible_interactions.pick_random()
	enemies = current_interaction.enemies
	
	if not cleared:
		for i in range(len(enemies)):
			
			var path = PathFollow3D.new()
			enemy_parent.add_child(path)
			
			path.rotation_mode = PathFollow3D.ROTATION_NONE
			path.progress_ratio = 0.5
			path.progress += enemy_separation * (i-float(len(enemies)-1)/2)
			await get_tree().process_frame
			
			var enemy_inst := enemies[i].instantiate()
			path.add_child(enemy_inst)
			Game.enemy_list.append(enemy_inst)
			
			lookat.position.y = max(lookat.position.y, enemy_inst.get_size().y/2)
			
			await get_tree().process_frame


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
#
#func _on_area_3d_body_entered(body: Node3D) -> void:
	#if body == Player.node and not cleared and not Game.is_in_combat:
		#Game.interaction_node = self
		#Game.interaction_started.emit()
		
		
#func _process(_delta: float) -> void:
	#if not Game.is_in_combat:
		#if enemy_parent.get_children() == []:
			#interaction_ended()
