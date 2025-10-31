extends Node

func start_turn(entity: Entity, effects: Dictionary):
	for effect in effects: 
		if effects[effect] != 0:
			effect.start_turn(entity, effects)
