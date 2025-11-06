extends Effect

func on_hit(entity):
	entity.health = min(entity.health+1,entity.max_health)
	entity.effects[3] = max(
		min(
			entity.effects[3],
			entity.max_health-entity.health
			)  -  1,
		0)
