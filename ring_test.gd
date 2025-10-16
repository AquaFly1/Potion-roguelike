extends Ring

func start_turn():
	if Player.burn == 0:
		Player.burn += 1

func hand_played(ings):
	tags = Array[Tag]
	if Player.burn > 0:
		tags.append("res://Resources/Tags/etincelle_tag.tres")
	return tags
