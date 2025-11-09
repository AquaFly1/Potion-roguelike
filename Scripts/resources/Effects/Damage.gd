extends Effect

func on_hit(entity):
	entity.take_damage(effects[0])
