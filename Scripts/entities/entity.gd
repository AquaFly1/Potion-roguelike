extends Node

class_name Entity

@export var rings: Array[Ring]
@export var max_health = 10


@onready var effects: Array


var health = 0


func _ready() -> void:
	effects.resize(Game.effects.size()) #have to use Game 
	effects.fill(0.0)
	health = max_health

func afflict_effect(amount):
	var amount_left = amount - effects[4]
	effects[4] -= amount
	if effects[4] < 0:
		effects[4] = 0
	health -= amount_left
	

func start_turn():
	Effect.call_start_turn(self)
	Ring.call_start_turn(self)



func _process(_delta: float) -> void:
	if health:
		if health <= 0:
			die()
	if health > max_health:
		health = max_health

func die():
	pass
