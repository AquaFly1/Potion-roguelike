extends Entity

@export var gold = 0
@export var level = 0
@export var xp = 0


@export var max_mana = 10
var mana = 0

@onready var node: CharacterBody3D

var xp_needed = 10

func _ready() -> void:
	super()
	gold = 0
	level = 0
	xp = 0
	xp_needed = 10


func start_turn():
	super()
	Game.player_start_turn.emit()
	mana = max_mana


func _process(_delta: float) -> void:
	if xp >= xp_needed:
		xp -= xp_needed
		xp_needed *= 2
		level += 1
