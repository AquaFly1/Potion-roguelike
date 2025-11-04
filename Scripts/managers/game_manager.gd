extends Node

@export var deck: Array[Ingredient]
@export var combos: Array[Combo]
@export var effects: Array[Effect]


var current_enemy: Enemy = null

var camera = null

var is_in_combat: bool = false

signal card_pressed(card: Card)
signal card_selected(card: Card)
signal end_turn()
signal player_start_turn()
signal interaction_started()
signal interaction_ended()
signal held_chand_modified(cards: Array)
signal look_candle(candle: Node3D)


var xp_end_of_fight: int = 0

func _ready() -> void:
	camera = get_viewport().get_camera_3d()
	interaction_started.connect(interaction_start_func)
	held_chand_modified.connect(chand_modified)
	card_selected.connect(card_selected_func)
	card_pressed.connect(card_pressed_func)
	end_turn.connect(end_turn_func)
	interaction_ended.connect(interaction_end_func)
	player_start_turn.connect(player_start_turn_func)
	look_candle.connect(player_look_candle)
	Player.rings = [load("res://Resources/rings/Ring_test.tres")]
	Effect.define_effects(effects)

func player_look_candle(_candle):
	pass
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
func interaction_start_func():
	pass
func card_pressed_func(_card):
	pass

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
