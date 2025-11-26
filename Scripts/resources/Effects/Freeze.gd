extends Effect

func start_turn(_entity):
	_entity.effects[Effect.index("Freeze")] -= 1.0
