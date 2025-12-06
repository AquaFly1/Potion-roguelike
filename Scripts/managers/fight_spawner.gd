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


@export var spawn_area_hitbox: CollisionShape3D

@export var fight_area_hitbox: CollisionShape3D

@export var path: Path3D

@export var player_pos: Marker3D

@export_group("Environnement")
@export var sides: int = 2
@export var Exits: Array[Node3D]
@export var enemy_separation: float

@onready var lookat: Node3D = $enemy_parent/LookAt
@onready var start_angle := rotation
var cleared: bool = false
var spawned: bool = false

@onready var original_rotation : Vector3 = rotation

func _ready() -> void:
	pass

func on_spawn_enemies_enter(_body: Node3D) -> void:

	
	look_at(Vector3(_body.global_position.x,global_position.y,_body.global_position.z))
	#await get_tree().create_timer(0).timeout
	
	
	rotation.y = fmod(rotation.y,PI/2) + PI
	rotation.y = start_angle.y + (rotation-start_angle).snappedf(2*PI/sides).y
	
	
	if spawn_enemies():
		spawn_area_hitbox.set_deferred("disabled",true)
		
		for i in Exits:
			i.block_exit()
		path.show()
			
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
		
		
		
		
		for i in range(min(Game.Flame,len(possible_interactions)-1), -1, -1):
			current_interaction_pool = possible_interactions[i]
			if not current_interaction_pool.is_empty(): 
				cleared = false
				break
		

		if not current_interaction_pool.is_empty():	
			spawned = true
			current_interaction = current_interaction_pool.pick_random()
			current_interaction_pool.clear()
			
			enemies = current_interaction.enemies
			
			load_enemies()
			
			path.hide()
	return spawned


func load_enemies():
	
		for i in range(len(enemies)):
			
			var path_f = PathFollow3D.new()
			path.add_child(path_f)
			
			
			path_f.rotation_mode = PathFollow3D.ROTATION_NONE
			path_f.progress_ratio = 0.5
			path_f.progress += enemy_separation * (i-float(len(enemies)-1)/2)
			
			
			var enemy_inst := enemies[i].instantiate()
			
			
			path_f.add_child(enemy_inst)
			Game.enemy_list.append(enemy_inst)
			
			lookat.position.y = max(lookat.position.y, enemy_inst.get_size().y/2)
			
			
	
