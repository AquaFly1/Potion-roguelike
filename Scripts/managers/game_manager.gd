extends Node

@export var deck: Array[Ingredient]
@export var combos: Array[Combo]
@export var rings: Array[Ring]

signal held_chand_modified(cards: Array)

var current_enemy: Enemy = null

var is_in_combat: bool = false

signal card_selected(card: Card)
signal end_turn()
signal player_start_turn()
signal interaction_ended()


var xp_end_of_fight: int = 0

func _ready() -> void:
	held_chand_modified.connect(chand_modified)
	card_selected.connect(card_selected_func)
	end_turn.connect(end_turn_func)
	interaction_ended.connect(interaction_end_func)
	player_start_turn.connect(player_start_turn_func)


func chand_modified(_cards: Array):
	pass
func card_selected_func(_card):
	pass
func end_turn_func():
	pass
func player_start_turn_func():
	pass
func interaction_end_func():
	pass


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
