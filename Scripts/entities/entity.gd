extends Node

class_name Entity

@export var rings: Array[Ring]
@export var max_health = 10

"""
effect order:
0 damage
1 burn
2 poison
3 rejuv
4 shield
5 strenght
6 weakness
7 fragility
8 frost
9 fuel

"""

@onready var effects: Array


var health = 0


func _ready() -> void:
	effects.resize(50)
	effects.fill(0.0)
	health = max_health

func take_damage(amount):
	var amount_left = amount - effects[4]
	effects[4] -= amount
	if effects[4] < 0:
		effects[4] = 0
	health -= amount_left
	

func start_turn():
	EffectMan.start_turn(self)
	RingMan.start_turn(self)



func _process(_delta: float) -> void:
	if health:
		if health <= 0:
			die()
	if health > max_health:
		health = max_health

func die():
	pass
