extends Effect

func end_turn(entity):
	if entity.effects[Effect.index("Freeze")] > 0:
		entity.effects[Effect.index("Freeze")] -= 1.0
		freeze_check(entity)
		
func on_hit(entity):
	freeze_check(entity)

func freeze_check(entity):
	entity.frozen = entity.effects[Effect.index("Freeze")] > 0
	
