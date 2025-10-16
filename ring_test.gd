extends Ring

func start_turn():
	if Player.burn == 0:
		Player.burn += 1

func hand_played(ings):
	var tags: Array[Tag]
	if Player.burn > 0:
		tags.append("res://Resources/Tags/etincelle_tag.tres")
	print(tags)
	return tags
