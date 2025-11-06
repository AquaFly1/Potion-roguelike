extends Effect

func end_turn(_entity):
	_entity.health -= 1
	_entity.effects[2] -= 1
