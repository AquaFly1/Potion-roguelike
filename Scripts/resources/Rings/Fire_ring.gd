extends Ring

func start_turn(entity):
	entity.effects[1] += 1

func potion_thrown(_ings):
	var tags: Array[Tag]
	if Player.effects[1] > 0:
		var burn_tag: Tag = load("res://Resources/Tags/etincelle_tag.tres")
		tags.append(burn_tag)
	return tags
