extends Node

var rings: Array[Ring]

func start_turn():
	for ring in rings:
		ring.start_turn()

func play_hand(ings: Array[Ingredient]):
	for ring in rings:
		ring.hand_played(ings)
