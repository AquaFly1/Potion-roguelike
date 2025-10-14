extends Ring

func start_turn():
	if Player.burn == 0:
		Player.burn += 1

func hand_played(ings):
	if Player.burn > 0:
		pass
