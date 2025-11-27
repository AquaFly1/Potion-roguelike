extends Effect

func start_turn(_entity):
	if _entity.effects[Effect.index("Freeze")] > 0:
		_entity.effects[Effect.index("Freeze")] -= 1.0
