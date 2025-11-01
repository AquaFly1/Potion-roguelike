extends Effect

func start_turn(_entity):
	_entity.health -= 2
	_entity.effects[2] -= 1
