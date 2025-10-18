extends Node

func start_turn():
	for ring in Game.rings:
		ring.start_turn()
