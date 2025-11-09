extends Effect

func on_hit(entity):
	entity.take_damage(entity.effects[0])
