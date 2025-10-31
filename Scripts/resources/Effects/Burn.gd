extends Effect

func start_turn(entity, effects):
	entity.health -= effects["Burn"]
	effects.burn -= 1
