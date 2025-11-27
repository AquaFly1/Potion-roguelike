extends Effect

func on_hit(_entity):
	if _entity.effects[Effect.index("Brittle")] > 0:
		_entity.effects[Effect.index("Brittle")] -= 1
