extends Node

class_name Entity

@export var rings: Array[Ring]
@export var max_health = 10
var shield = 0

var health = 0
var burn = 0
var poison = 0
var rejuv = 0
var freeze = 0
var block = 0

func _ready() -> void:
	health = max_health

func take_damage(amount):
	var amount_left = amount - shield
	shield -= amount
	if shield < 0:
		shield = 0
	health -= amount_left
	

func start_turn():
	health -= burn
	burn = 0

	if poison > 0:
		health -= poison
		poison -= 1

	if health <= 0:
		die()
	
	if block > 0:
		shield = block
		block = 0

	if rejuv > 0:
		health += 1
		rejuv -= 1
	
	if freeze > 0:
		freeze -= 1
		return



func _process(_delta: float) -> void:
	if health:
		if health <= 0:
			die()
	if health > max_health:
		health = max_health

func die():
	pass
