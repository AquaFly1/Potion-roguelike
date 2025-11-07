extends StaticBody3D

@export var cards: Array[Ingredient]
@onready var card_label: Label = $card_label

func open_chest():
	var card = cards.pick_random()
	Game.deck.append(card)
	card_label.visible = true
	card_label.text = ("%s obtained" % card.name)
	await get_tree().create_timer(2).timeout
	card_label.visible = false
