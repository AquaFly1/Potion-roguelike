extends Effect

func on_hit(_entity):
	_entity.effects[Effect.index("Brittle")] -= 1
