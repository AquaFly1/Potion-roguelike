extends Ring

func potion_thrown(ings: Array[Ingredient]) -> Array[Tag]:
	for ingredient in ings:
		if ingredient.name == "Ice shard":
			bonus_damage += 1
	return []
