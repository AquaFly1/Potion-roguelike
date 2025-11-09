extends Node

@export var deck: Array[Ingredient]
@export var combos: Array[Combo]
@export var effects: Array[Effect]


var enemy_list: Array[Enemy] ##The array of [member enemies] of this combat. [br]Empty if out of combat.
#u
var current_enemy: Enemy = null

var camera = null
@onready var screen_size : Vector2 = get_viewport().size

var is_in_combat: bool = false

signal card_pressed(card: Card)
signal card_selected(card: Card)
signal turn_ended() ##Gets called when an [member entity] finishes it's turn
signal player_start_turn()
signal enemy_start_turn()
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
	turn_ended.connect(turn_ended_func) 
	interaction_ended.connect(interaction_end_func)
	player_start_turn.connect(call_player_turn)
	enemy_start_turn.connect(call_enemies_turn)
	look_candle.connect(player_look_candle)
	Effect.define_effects(effects)
	for combo in combos:
		combo.set_upgrade()
##Iterates through all [member enemies] in 
##[member enemy_list] and starts their turn 
func call_enemies_turn():
	for i in enemy_list.duplicate():
		await i.start_turn()
		print("waiting")
		await get_tree().create_timer(0.5).timeout
	if enemy_list.size() != 0:
		player_start_turn.emit()
	else:
		interaction_ended.emit()

func call_player_turn():
	if enemy_list.size() != 0:
		await Player.start_turn()
		enemy_start_turn.emit()
	

func player_look_candle(_candle):
	pass
func chand_modified(_cards: Array):
	pass
func card_selected_func(_card):
	pass
func turn_ended_func():
	pass
func interaction_end_func():
	is_in_combat = false
	Player.xp += xp_end_of_fight
	xp_end_of_fight = 0
	
func interaction_start_func():
	player_start_turn.emit()
func card_pressed_func(_card):
	pass

func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
	if Input.is_action_just_pressed("window_fullscreen"):
		if DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_FULLSCREEN:
			
			
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			
			
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			
	
