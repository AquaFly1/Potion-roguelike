extends Node

class_name Entity

@export var rings: Array[Ring]
@export var max_health = 10

var health = 0
var burn = 0
var poison = 0
var rejuv = 0

func _ready() -> void:
	health = max_health

func start_turn():
	health -= burn
	burn = 0

	if poison > 0:
		health -= 1
		poison -= 1

	if health <= 0:
		die()

	if rejuv > 0:
		health += 1
		rejuv -= 1
	
func _process(_delta: float) -> void:
	if health:
		if health <= 0:
			die()
	if health > max_health:
		health = max_health

func die():
	pass
