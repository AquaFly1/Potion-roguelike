extends Ring

func start_turn():
	if Player.burn == 0:
		Player.burn += 1

func hand_played(ings):
	var tags: Array[Tag]
	if Player.burn > 0:
		var burn_tag: Tag = load("res://Resources/Tags/etincelle_tag.tres")
		tags.append(burn_tag)
	return tags
