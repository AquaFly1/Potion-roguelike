extends Ring

func start_turn():
	if Player.burn == 0:
		Player.burn += 1

func hand_played(ings):
	if Player.burn > 0:
		return "res://Resources/Tags/etincelle_tag.tres"
	return
