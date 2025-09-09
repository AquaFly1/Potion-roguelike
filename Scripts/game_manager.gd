extends Node

@export var deck: Array[Ingredient]

@export var combos: Array[Combo]

var current_enemy: Enemy = null

signal card_selected(card: Card)
signal end_turn()


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

func _ready() -> void:
	pass
