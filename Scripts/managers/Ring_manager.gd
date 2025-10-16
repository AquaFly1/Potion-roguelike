extends Node

@export var rings: Array[PackedScene]

func start_turn():
	for ring in rings:
		ring.start_turn()

func play_hand(ings: Array[Ingredient]) -> Array[Tag]:
	var tags: Array[Tag]
	print(ings)

	for ing in ings:
		for tag in ing.tags:
			tags.append(tag)
	
	for ring in rings:
		for tag in ring.hand_played(ings):
			tag.append(tag)
	print(tags)
	return tags
