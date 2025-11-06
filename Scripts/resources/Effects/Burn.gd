extends Effect

func end_turn(_entity):
	print("burning ",_entity.name," with ",_entity.effects[1]," damage")
	_entity.health -= _entity.effects[1]
	#if _entity.effects[9] > 0:
		#_entity.effects[1] -= 1
	#else:
	_entity.effects[1] = 0
