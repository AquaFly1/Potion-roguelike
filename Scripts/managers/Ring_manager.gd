extends Node

func start_turn():
	for ring in Game.rings:
		ring.start_turn()

func play_hand(ings: Array[Ingredient]) -> Array[Tag]:
	var tags: Array[Tag]

	for ing in ings:
		tags.append_array(ing.tags)
	
	for ring in Game.rings:
		tags.append_array(ring.hand_played(ings))

	return tags
