extends Effect

func afflict_effect(_entity):
	if _entity is Player: print(_entity.effects[0])
	_entity.health -= _entity.effects[0]
	_entity.effects[0] = 0
