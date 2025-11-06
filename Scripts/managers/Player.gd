extends Entity

var gold = 0
var level = 0
var xp = 0


var max_mana = 10
var mana = 0

var node: CharacterBody3D
var health_bar : Control

var xp_needed = 10

func _ready() -> void:
	super()
	gold = 0
	level = 0
	xp = 0
	xp_needed = 10


func start_turn():
	super()
	
func end_turn():
	super()
	
	


func _process(_delta: float) -> void:
	if xp >= xp_needed:
		xp -= xp_needed
		xp_needed *= 2
		level += 1
