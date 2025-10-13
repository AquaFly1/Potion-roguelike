extends Node

class_name Entity

@export var max_health = 10

var health = 0

var burn = 0
var poison = 0
var rejuv = 0

func take_potion(potion):
	var damages = Game.apply_potion(potion)
	health -= damages[0]
	burn += damages[1]
	poison += damages[2]
	rejuv += damages[3]
	health += damages[4]

func _ready() -> void:
	health = max_health

func start_turn():
	health -= burn
	burn = 0

	if poison > 0:
		health -= 1
		poison -= 1

	if rejuv > 0:
		health += 1
		rejuv -= 1

func _process(_delta: float) -> void:
	pass
