extends Node

@export var deck: Array[Ingredient]
@export var combos: Array[Combo]
@export var effects: Array[Effect]

@export var strength_multiplier: int = 2
@export var weakness_multiplier: int = 2

var main_node: Node3D
var mouse_mode: int


var enemy_list: Array[Enemy] ##The array of [member enemies] of this combat. [br]Empty if out of combat.

signal enemy_selected(enemy: Enemy)
var current_enemy: Enemy = null:
	set(value):
		current_enemy = value
		enemy_selected.emit(value)

var camera = null
@onready var screen_size : Vector2 = get_viewport().size

var Flame := 0
var is_in_combat: bool = false

signal card_pressed(card: Card)
signal card_selected(card: Card)

signal player_start_turn

signal enemy_start_turn
signal enemy_turn_ended
signal enemy_killed
var waiting_for_enemy: bool

signal interaction_started(node: Node3D)
signal interaction_ended(win: bool)
var interaction_node: Node3D

signal held_chand_modified(cards: Array)
signal look_candle(candle: Node3D)


var xp_end_of_fight: int = 0

func _ready() -> void:
	camera = get_viewport().get_camera_3d()
	interaction_started.connect(interaction_start_func)
	held_chand_modified.connect(chand_modified)
	card_selected.connect(card_selected_func)
	card_pressed.connect(card_pressed_func)
	interaction_ended.connect(interaction_end_func)
	player_start_turn.connect(call_player_turn)
	enemy_start_turn.connect(call_enemies_turn)
	enemy_killed.connect(enemy_killed_func)
	look_candle.connect(player_look_candle)
	Effect.define_effects(effects)
	for combo in combos:
		combo.set_upgrade()
##Iterates through all [member enemies] in 
##[member enemy_list] and starts their turn 
func call_enemies_turn():
	for i in enemy_list.duplicate():
		waiting_for_enemy = true
		wait_for_enemy_turn(i)
		await enemy_turn_ended
		waiting_for_enemy = false
		await get_tree().create_timer(0.5).timeout
	if enemy_list.size() != 0:
		player_start_turn.emit()
	else:
		interaction_ended.emit()

func call_player_turn():
	if enemy_list.size() != 0:
		await Player.start_turn()
		enemy_start_turn.emit()

func wait_for_enemy_turn(entity: Entity):
	await entity.start_turn()
	if waiting_for_enemy:
		enemy_turn_ended.emit()
		
func enemy_killed_func():
	if waiting_for_enemy:
		enemy_turn_ended.emit()
	if enemy_list.is_empty():	interaction_ended.emit()
	

func player_look_candle(_candle):
	pass
func chand_modified(_cards: Array):
	pass
func card_selected_func(_card):
	pass
func interaction_end_func():
	is_in_combat = false
	Player.xp += xp_end_of_fight
	xp_end_of_fight = 0
	
func interaction_start_func():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	player_start_turn.emit()
func card_pressed_func(_card):
	pass


func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("window_fullscreen"):
		if DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_FULLSCREEN:
			
			
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			
			
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			
	
