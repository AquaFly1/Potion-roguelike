extends Node2D

var current_enemy = null

@export var goblin_scene: PackedScene
@onready var enemies_parent: Node = $enemies_parent

@export var enemies: Array[PackedScene]

func _ready() -> void:
	Game.end_turn.connect(end_turn)
	
	#temporary
	var pos = 0
	for enemy in enemies:
		var enemi = enemy.instantiate()
		enemies_parent.add_child(enemi)
		enemi.position.x += pos
		pos += 200
	
	#var goblin = goblin_scene.instantiate()
	#add_child(goblin)
	#goblin.position.y -= 300

func end_turn():
	for enemy in enemies_parent.get_children():
		enemy.start_turn()
