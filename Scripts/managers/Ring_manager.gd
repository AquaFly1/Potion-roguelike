extends Node

func start_turn(_entity: Entity):
	for ring in _entity.rings:
		ring.start_turn()
