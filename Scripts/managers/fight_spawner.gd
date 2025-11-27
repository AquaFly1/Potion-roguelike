@tool
extends Node3D

@export var respawn_enemies: bool = true ##The interactions will be permanently cleared, higher [member Flame] will not spawn new enemies.
##Array of possible fights for each [member Flame] reached. 
##[br][br]The spawner will look for the most difficult interaction possible with the current [member Flame],
## and spawns enemies if that interaction was not cleared.
## This means it is possible to skip lower-level interactions if a higher interaction exists, even if the latter is cleared.
##[br][br]Leave empty spaces if reaching a higher [member Flame] doesn't spawn new enemies for that [member Flame]
@export var possible_interactions: Array[Array]
var current_interaction_pool: Array
var current_interaction = []
var enemies: Array[PackedScene]

#@export var text: String:
	#set(value):
		#if Engine.is_editor_hint():
			#text = value
			#print(value)

@export_group("Hitboxes")
@export var make_shape_duplicate:bool=false:
	set(value):
		make_shape_duplicate = value
		spawn_area_hitbox.shape = spawn_area_hitbox.shape.duplicate()
		fight_area_hitbox.shape = spawn_area_hitbox.shape.duplicate()
@export_subgroup("Spawn Hitbox","spawn_")
@export var spawn_area_hitbox: CollisionShape3D
@export var spawn_hitbox_position: Vector3:
	set(value):
		spawn_hitbox_position = value
		_update_hitbox(spawn_area_hitbox,"position",value)
@export var spawn_hitbox_rotation: Vector3:
	set(value):
		spawn_hitbox_rotation = value
		_update_hitbox(spawn_area_hitbox,"rotation",value)
@export var spawn_hitbox_scale: Vector3 = Vector3(4,5,4):
	set(value):
		spawn_hitbox_scale = value
		_update_hitbox(spawn_area_hitbox,"scale",value)

@export_subgroup("Fight Hitbox","fight_")
@export var fight_area_hitbox: CollisionShape3D
@export var fight_hitbox_position: Vector3:
	set(value):
		fight_hitbox_position = value
		_update_hitbox(fight_area_hitbox,"position",value)
@export var fight_hitbox_rotation: Vector3:
	set(value):
		fight_hitbox_rotation = value
		_update_hitbox(fight_area_hitbox,"rotation",value)
@export var fight_hitbox_scale: Vector3 = Vector3(3,5,1):
	set(value):
		fight_hitbox_scale = value
		_update_hitbox(fight_area_hitbox,"scale",value)

@export_subgroup("Path","path")
@export var path: Path3D
@export var path_offset: Vector3 =  Vector3(0,0,-3):
	set(value):
		path_offset = value
		_update_hitbox(path,"position",value)

func _update_hitbox(coll:Node3D,type:String, value: Vector3):
	#if Engine.is_editor_hint():
		match type:
			"position":
				coll.position = value
			"rotation":
				coll.rotation = value
			"scale":
				coll.shape.size = value

@export_group("Environnement")
@export var sides: int = 2
@export var Exits: Array[Node3D]
@export var enemy_separation: float

@onready var lookat: Node3D = $enemy_parent/LookAt
@onready var start_angle := rotation
var cleared: bool = false
var spawned: bool = false

func _ready() -> void:
	pass

func on_spawn_enemies_enter(_body: Node3D) -> void:

	
	look_at(_body.global_position)
	#await get_tree().create_timer(0).timeout
	
	
	rotation.y = fmod(rotation.y,PI/2) + PI
	rotation.y = start_angle.y + (rotation-start_angle).snappedf(2*PI/sides).y
	
	
	if spawn_enemies():
		for i in Exits:
			i.block_exit()
		
		
		load_enemies()
			
		await Game.interaction_ended
		spawned = false
		spawn_area_hitbox.set_deferred("disabled",false)
		for i in Exits:
			i.block_exit(true)
	
	
func on_start_fight_entered(_body: Node3D) -> void:
	if not cleared and not Game.is_in_combat:
		Game.interaction_node = self
		Game.interaction_started.emit()

func spawn_enemies():
	if not spawned:	
		
		spawned = true
		spawn_area_hitbox.set_deferred("disabled",true)
		
		for i in range(min(Game.Flame,len(possible_interactions)-1), -1, -1):
			current_interaction_pool = possible_interactions[i]
			if len(current_interaction_pool)!=0: 
				cleared = false
				break
		

			
		current_interaction = current_interaction_pool.pick_random()
		current_interaction_pool.clear()
		
		enemies = current_interaction.enemies
		
	return spawned


func load_enemies():
	
		for i in range(len(enemies)):
			
			var path_f = PathFollow3D.new()
			path.add_child(path_f)
			
			path_f.rotation_mode = PathFollow3D.ROTATION_NONE
			path_f.progress_ratio = 0.5
			path_f.progress += enemy_separation * (i-float(len(enemies)-1)/2)
			await get_tree().process_frame
			
			var enemy_inst := enemies[i].instantiate()
			path_f.add_child(enemy_inst)
			Game.enemy_list.append(enemy_inst)
			
			lookat.position.y = max(lookat.position.y, enemy_inst.get_size().y/2)
			
			await get_tree().process_frame
			
	
