extends Effect

func start_turn(_entity):
	if _entity.effects[2] > 0:
		_entity.health -= 2
		_entity.effects[2] -= 1
