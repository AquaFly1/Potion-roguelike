extends Node3D

@export var cards: Array[Ingredient]
@onready var card_label: Label = $CanvasLayer/card_label
@onready var collision_shape_3d: CollisionShape3D = $Chest/CollisionShape3D

func open_chest():
	var card = cards.pick_random()
	Game.deck.append(card)
	card_label.visible = true
	card_label.text = ("%s obtained" % card.name)
	collision_shape_3d.disabled = true 
	await get_tree().create_timer(2).timeout
	card_label.visible = false
	
