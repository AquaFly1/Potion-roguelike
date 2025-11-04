extends Effect

func start_turn(_entity):
	if _entity is Player: print(_entity.effects[2])
	_entity.health -= _entity.effects[2]
	#if _entity.effects[9] > 0:
		#_entity.effects[1] -= 1
	#else:
	_entity.effects[1] = 0
