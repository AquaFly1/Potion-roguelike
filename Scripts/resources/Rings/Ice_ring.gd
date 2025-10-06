extends Ring

func activate(ings = Array[Ingredient]):
	for ingredient in ings:
		if ingredient.name == "Ice shard":
			bonus_damage += 1
