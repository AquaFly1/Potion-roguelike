extends Node2D

var current_enemy = null

@export var goblin_scene: PackedScene
@onready var enemies_parent: Node = $enemies_parent

@export var enemies: Array[PackedScene]

var fight_ended = false

func _ready() -> void:
	Game.end_turn.connect(end_turn)
	Player.start_turn()
	
	#temporary
	var pos = 0
	for enemy in enemies:
		var enemi = enemy.instantiate()
		enemies_parent.add_child(enemi)
		enemi.position.x += pos
		pos += 200

func end_turn():
	for enemy in enemies_parent.get_children():
		enemy.start_turn()
	Player.start_turn()

func _process(delta: float) -> void:
	if fight_ended == false:
		if enemies == []:
			end_fight()


func end_fight():
	fight_ended = true
	Player.xp += Game.xp_end_of_fight
	Game.xp_end_of_fight = 0
