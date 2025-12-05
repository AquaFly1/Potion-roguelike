extends Area3D
@export var area_other: Area3D
@export var fade_mesh : MeshInstance3D
@export var fade_mesh_other : MeshInstance3D
@onready var parent : Node3D = $".."
@export var zone: CollisionShape3D
var fade_target_value: float = 1
var fading: bool = false
@onready var block_player_light: Node3D = fade_mesh.get_child(0)
var candle: Node3D
@onready var block: CollisionShape3D = $"../StaticBody3D/block"
var side := -1

func _ready() -> void:
	if name == "Side1Area-nx":
		candle = parent.Side1Candle
		
		
	else:
		candle = parent.Side2Candle
		side = 1
	connect("body_entered",on_body_entered)
	connect("body_exited",on_body_exited)
	#if candle: candle.changed.connect(update_hitbox)
	
func update_hitbox() -> void:
	if side == -1 and parent.side_1_interaction and parent.side_1_interaction.spawned: return
	if side == 1 and parent.side_2_interaction and parent.side_2_interaction.spawned: return
	block.set_deferred("disabled", true)
	if not parent.secret_passage: 
		if candle: print(candle.active)
		if candle and sign(parent.get_player_distance()) == side:
			
			parent.block_exit(candle.active)
	
	
func on_body_entered(_body: Node3D) -> void:
	#first half
	update_hitbox()
	
	if fade_mesh.transparency == 1:
		fade_mesh_other.transparency = 0
		
		
		
	else:
		area_other.fading = false
		fading = true
		Player.node.horizontal_velocity = Vector3.ZERO
		Player.node.velocity = Vector3.ZERO

		if side == -1:
			if parent.side_1_interaction:
				if parent.show_enemies_1_immediately: parent.side_1_interaction.on_spawn_enemies_enter(Player.node)
				else:	parent.side_1_interaction.spawn_enemies()
		else: 
			if parent.side_2_interaction:
				if parent.show_enemies_2_immediately: parent.side_2_interaction.on_spawn_enemies_enter(Player.node)
				else:	parent.side_2_interaction.spawn_enemies()
		
			
		
		if candle:
			candle.affect_player_light = true
			if area_other.candle: area_other.candle.affect_player_light = false
			if not candle.active:
				block_player_light.visible = true
			candle.update_player_light()
		else:
			if area_other.candle and not area_other.candle.active:
				Player.node.self_dark_light.show()
		if area_other.candle:
			area_other.candle.update_player_dark_light()
	

func on_body_exited(_body: Node3D) -> void:
	
	
	if abs(parent.get_player_distance()) > parent.scale.z:
		fade_mesh_other.transparency = 1
		fade_mesh.transparency = 1
		fading = false
		area_other.block_player_light.visible = false
		block_player_light.visible = false
		
		
		
	
func _physics_process(_delta: float) -> void:
	if fading:
		
		fade_mesh.transparency = lerp(fade_mesh.transparency,1.,0.2)
		fade_mesh_other.transparency = 1 - fade_mesh.transparency
		if abs(1-fade_mesh.transparency) < 0.05:
			fade_mesh.transparency = 1
			fade_mesh_other.transparency = 0
			area_other.block_player_light.visible = false
			block_player_light.visible = false
			fading = false
