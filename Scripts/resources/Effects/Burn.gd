extends Effect

func end_turn(_entity):
	var damage = min(_entity.effects[1],_entity.health)
	_entity.take_damage(damage)
	_entity.effects[1] -= damage
	
