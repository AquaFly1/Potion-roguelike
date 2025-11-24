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
	if await load_enemies():
		for i in Exits:
			i.block_exit()
			
		await Game.interaction_ended
		
		for i in Exits:
			i.block_exit(true)
	
	
func on_start_fight_entered(_body: Node3D) -> void:
	if not cleared and not Game.is_in_combat:
		Game.interaction_node = self
		Game.interaction_started.emit()

func load_enemies():
	for i in range(min(Game.Flame,len(possible_interactions)-1), -1, -1):
		current_interaction_pool = possible_interactions[i]
		if len(current_interaction_pool)!=0: break
	
	current_interaction = current_interaction_pool.pick_random()
	
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
		
	return not cleared
