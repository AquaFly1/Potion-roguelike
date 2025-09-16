extends Control

@export var hand_size: int = 5
@export var card_spacing: float = 100.0

@export var card_scene: PackedScene
@export var path_scene: PackedScene

var selected_card: Card
var cards: Array[Card]

var has_potion = false
@onready var potion_sprite: TextureRect = $potion_sprite

@onready var mana_bar: TextureProgressBar = $TextureProgressBar

@export var hand_path: Path2D

@export var deck: Array[Ingredient]


var use_deck: Array[Ingredient]
var potion: Array[Ingredient]

func _ready() -> void:
	Game.player_start_turn.connect(player_start)
	Game.card_selected.connect(on_selected_card)
	draw(4)
	

	
func add_card(card_ing):
	#if cards.size() >= hand_size:
		#return
	var card = card_scene.instantiate()
	var card_path = path_scene.instantiate()
	card.ingredient = card_ing
	card.path = card_path
	card.path_pos_index = float(cards.size())/max(5,cards.size())
	add_child(card)
	hand_path.add_child(card_path)
	card_path.set("position",Vector2(0,0))
	cards.append(card)
	use_deck.pop_at(0)
	
	_update_hand_layout()

func remove_card(card):
	if card in cards:
		card.path.queue_free()
		cards.erase(card)
		
		card.queue_free()
		
		_update_hand_layout()

func _update_hand_layout():
	var total = cards.size()
	if total == 0:
		Game.held_hand_modified.emit(cards)
		return
	var start_x = -((total - 1) * card_spacing) / 2
	for i in range(total):
		var target_pos = Vector2(start_x + i * card_spacing, 0)
		cards[i].move_to_position()
	Game.held_hand_modified.emit(cards)

func on_selected_card(card):
	selected_card = card
	for i in cards:
		if i.path_pos_index < selected_card.path_pos_index:
			i.path_pos_index += 1.0/max(5,cards.size())
	selected_card.path_pos_index = 0
	_update_hand_layout()

func _on_play_pressed() -> void:
	if has_potion:
		if Player.mana > 0:
			if selected_card:
				potion.append(selected_card.ingredient)
				remove_card(selected_card)
				Player.mana -= 1
				for i in cards:
					i.path_pos_index -= 1.0/max(5,cards.size())
				draw(1)
				selected_card = null
				
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
		_update_hand_layout()
		for i in cards:
			i.path_pos_index -= 1.0/max(5,cards.size())
		if cards.size() < hand_size:
			draw(1)
		selected_card = null
				


func _on_draw_pressed() -> void:
	print(use_deck)
	draw(1)

func draw(amount: int):
	for i in amount:
		if use_deck != []:
			add_card(use_deck[0])
			_update_hand_layout()

func player_start():
	print("start player turn")
	deck.shuffle()
	use_deck = deck.duplicate()
	for card in cards:
		remove_card(card)
	cards = []
	_update_hand_layout()
	draw(4)
	selected_card = null
