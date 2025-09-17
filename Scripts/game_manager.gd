extends Node

@export var deck: Array[Ingredient]
@export var combos: Array[Combo]

signal held_hand_modified(cards: Array)

var current_enemy: Enemy = null

signal card_selected(card: Card)
signal end_turn()
signal player_start_turn()

var xp_end_of_fight: int = 0

func _ready() -> void:
	held_hand_modified.connect(hand_modified)
	card_selected.connect(card_selected_func)
	end_turn.connect(end_turn_func)
	player_start_turn.connect(player_start_turn_func)
	pass

func hand_modified(_cards: Array):
	pass
func card_selected_func(_card):
	pass
func end_turn_func():
	pass
func player_start_turn_func():
	pass

func apply_potion(ingredients: Array[Ingredient]):
	var active_combos = ComboMan.find_combos(ingredients)
	var dmg = 0
	var burn = 0
	var poison = 0
	var rejuv = 0
	var heal = 0
	for combo in active_combos:
		dmg += combo.dmg
		burn += combo.burn
		poison += combo.poison
		rejuv += combo.rejuv
		heal += combo.heal
	return[dmg, burn, poison, rejuv, heal]


	
