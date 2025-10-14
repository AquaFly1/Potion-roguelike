extends Node2D

class_name Ring

@export var ring_name: String
@export_multiline var description: String

var bonus_damage: int = 0

func activate(ings: Array[Ingredient]):
	pass

func hand_played(ings: Array[Ingredient]):
	pass
	
func start_turn():
	pass
