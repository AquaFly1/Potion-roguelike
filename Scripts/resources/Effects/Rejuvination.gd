extends Effect

func start_turn(_entity):
	if _entity.effects[3] > 0:
		_entity.health += 1
		_entity.effects[3] -= 1
