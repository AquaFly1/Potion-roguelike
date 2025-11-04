extends Effect

func on_hit(entity):
	entity.effects[0] = entity.effects[0] - entity.effects[4]
	entity.effects[4] -= min(entity.effects[0],0)
	
	entity.health -= entity.effects[0] * 20
	entity.effects[0] = 0
	
