extends Control

@export var hand_size: int = 3
@export var card_spacing: float = 100.0

@export var card_scene: PackedScene

var selected_card: Card
var cards: Array[Card]

var has_potion = false

#mana
var mana: int = Player.potion_bars

@onready var mana_container: HBoxContainer = $mana

var mana_texture = load("res://Sprites/temporary_art/potion_bar.aseprite")
var mana_empty = load("res://Sprites/temporary_art/potion_bar_empty.aseprite")

@export var deck: Array[Ingredient]
var use_deck: Array[Ingredient]
var potion: Array[Ingredient]

func _ready() -> void:
	
	for i in mana:
		var mana_bar = TextureRect.new()
		mana_container.add_child(mana_bar)
		mana_bar.texture = mana_texture
		mana_bar.custom_minimum_size.x = 100
	
	Game.card_selected.connect(on_selected_card)
	deck.shuffle()
	use_deck = deck.duplicate()
	add_card(use_deck[0])
	add_card(use_deck[0])
	add_card(use_deck[0])
	
	
func add_card(card_ing):
	if cards.size() >= hand_size:
		return
	var card = card_scene.instantiate()
	card.ingredient = card_ing
	add_child(card)
	cards.append(card)
	use_deck.pop_at(0)
	_update_hand_layout()

func remove_card(card):
	if card in cards:
		cards.erase(card)
		card.queue_free()
		_update_hand_layout()

func _update_hand_layout():
	var total = cards.size()
	if total == 0:
		return
	var start_x = -((total - 1) * card_spacing) / 2
	for i in range(total):
		var target_pos = Vector2(start_x + i * card_spacing, 0)
		cards[i].move_to_position(target_pos)

func on_selected_card(card):
	selected_card = card

func _on_draw_pressed() -> void:
	if cards.size() < hand_size:
		if use_deck != []:
			add_card(use_deck[0])
		else:
			deck.shuffle()
			use_deck = deck.duplicate()

func _on_play_pressed() -> void:
	if has_potion:
		if selected_card:
			potion.append(selected_card.ingredient)
			remove_card(selected_card)
			mana -= 1

func _on_throw_pot_pressed() -> void:
	if Game.current_enemy:
		Game.current_enemy.take_potion(potion)
		potion = []

func _on_end_turn_pressed() -> void:
	Game.end_turn.emit()


func _on_throw_self_pressed() -> void:
	Player.take_potion(potion)
	print(potion, Player.health)
	potion = []
	


func _on_get_potion_pressed() -> void:
	if has_potion == false:
		mana -= 1
		has_potion = true
