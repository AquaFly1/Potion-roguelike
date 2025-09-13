extends Control

@export var hand_size: int = 3
@export var card_spacing: float = 100.0

@export var card_scene: PackedScene

var selected_card: Card
var cards: Array[Card]

var has_potion = false
@onready var potion_sprite: TextureRect = $potion_sprite

@onready var mana_bar: TextureProgressBar = $TextureProgressBar

@export var deck: Array[Ingredient]
var use_deck: Array[Ingredient]
var potion: Array[Ingredient]

func _ready() -> void:
	Game.card_selected.connect(on_selected_card)
	deck.shuffle()
	use_deck = deck.duplicate()
	add_card(use_deck[0])
	add_card(use_deck[0])
	add_card(use_deck[0])
	Game.held_hand_modified.emit(cards)
	
func add_card(card_ing):
	if cards.size() >= hand_size:
		return
	var card = card_scene.instantiate()
	card.ingredient = card_ing
	add_child(card)
	cards.append(card)
	use_deck.pop_at(0)
	_update_hand_layout()
	Game.held_hand_modified.emit(cards)

func remove_card(card):
	if card in cards:
		cards.erase(card)
		card.queue_free()
		_update_hand_layout()
	Game.held_hand_modified.emit(cards)

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

func _on_play_pressed() -> void:
	if has_potion:
		if Player.mana > 0:
			if selected_card:
				potion.append(selected_card.ingredient)
				remove_card(selected_card)
				Player.mana -= 1
				Game.held_hand_modified.emit(cards)

func _on_throw_pot_pressed() -> void:
	if Game.current_enemy:
		Game.current_enemy.take_potion(potion)
		potion = []
		has_potion = false

func _on_end_turn_pressed() -> void:
	Game.end_turn.emit()
	has_potion = false


func _on_throw_self_pressed() -> void:
	Player.take_potion(potion)
	potion = []
	has_potion = false
	


func _on_get_potion_pressed() -> void:
	if Player.mana > 0:
		if has_potion == false:
			Player.mana -= 1
			has_potion = true

func _process(delta: float) -> void:
	mana_bar.value = Player.mana
	if has_potion:
		potion_sprite.visible = true
	else:
		potion_sprite.visible = false


func _on_discard_pressed() -> void:
	if selected_card:
		cards.erase(selected_card)
		selected_card.queue_free()
		if cards.size() < hand_size:
			if use_deck != []:
				add_card(use_deck[0])
		selected_card = null
		Game.held_hand_modified.emit(cards)
