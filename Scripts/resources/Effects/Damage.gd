extends Effect

func on_hit(entity):
	await entity.take_damage(
		(entity.effects[0])
		*(entity.effects[Effect.index("Brittle")]+1))
	entity.effects[0] = 0
	await super(entity)
	
