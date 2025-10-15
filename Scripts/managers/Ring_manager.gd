extends Node

@export var rings: Array[PackedScene]

func start_turn():
	for ring in rings:
		ring.start_turn()

func play_hand(ings: Array[Ingredient]):
	var extra_tags = []
	var total_tags = []
	for ring in rings:
		extra_tags.append(ring.hand_played(ings))
	for ing in ings:
		total_tags.append(ing.tags)
	total_tags.append(extra_tags)
	return total_tags
