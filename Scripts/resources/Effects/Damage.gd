extends Effect

func take_damage(_entity):
	_entity.health -= _entity.effects[0]
	_entity.effects[0] = 0
