extends Entity

@export var gold = 0
@export var level = 0
@export var xp = 0

@export var max_mana = 10
var mana = 10

var xp_needed = 10

func _ready() -> void:
	pass


func start_turn():
	super()
	mana = max_mana
	Game.player_start_turn.emit()

func _process(_delta: float) -> void:
	if xp >= xp_needed:
		xp -= xp_needed
		xp_needed *= 2
		level += 1
