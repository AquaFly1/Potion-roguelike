extends Node

@export var effects: Array[Effect]




func start_turn(entity):
	for effect in effects:
		if entity.effects[effects[effect]] != 0:
			effect.start_turn(entity)

func take_damage(entity):
	for effect in effects:
		if entity.effects[effects[effect]] != 0:
			effect.take_damage(entity)

func give_damage(entity):
	for effect in effects:
		if entity.effects[effects[effect]] != 0:
			effect.give_damage(entity)
