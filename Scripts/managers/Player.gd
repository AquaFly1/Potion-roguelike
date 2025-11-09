extends Entity

var gold = 20
var level = 0
var xp = 0

var exposed: bool = false

var max_mana = 10
var mana = 0

var node: CharacterBody3D

var xp_needed = 10

@warning_ignore("unused_signal")
signal player_ready ##Called when the Player.node is ready

signal death

signal turn_ended


func _ready() -> void:
	super()

func start_turn():
	await super()
	await turn_ended
	await end_turn()
	
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
		effects.fill(0)
		exposed = true
		health_bar.update_bar()
	else:
		Player.death.emit()
	
	health_bar.visible = not exposed

func game_over():
	pass
