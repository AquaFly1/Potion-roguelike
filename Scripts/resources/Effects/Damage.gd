extends Effect

func on_hit(entity):
	entity.take_damage((entity.effects[0]+entity.effects[Effect.index("Freeze")])*(entity.effects[Effect.index("Brittle")]+1))
