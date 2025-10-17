extends Node

func start_turn():
	for ring in Game.rings:
		ring.start_turn()

func play_hand(ings: Array[Ingredient], rings: Array[Ring]) -> Array[Tag]:
	var tags: Array[Tag]

	for ring in rings:
		tags.append_array(ring.hand_played(ings))

	return tags
