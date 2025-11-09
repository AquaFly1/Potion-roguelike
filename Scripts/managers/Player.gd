extends Entity

var gold = 0
var level = 0
var xp = 0

var exposed: bool = false

var max_mana = 10
var mana = 0

var node: CharacterBody3D
var health_bar : Control

var xp_needed = 10

func _ready() -> void:
	super()
	gold = 20
	level = 0
	xp = 0
	xp_needed = 10

func start_turn():
	await super()
	
func end_turn():
	await super()

func _process(_delta: float) -> void:
	if xp >= xp_needed:
		xp -= xp_needed
		xp_needed *= 2
		level += 1


func die():
	if not exposed:
		health = 0
		effects.clear()
		exposed = true
	else:
		game_over()

func game_over():
	pass
