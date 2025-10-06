extends Control

@export var hand_size: int = 5
@export var card_spacing: float = 100.0

@export var card_scene: PackedScene
@export var path_scene: PackedScene

var selected_cards: Array[Card]
var cards: Array[Card]
var card_order: Array[Card] #card order for making sure we click the right card

var has_potion = false
@onready var potion_sprite: Sprite2D = $"../Player/Potion"

@onready var mana_bar: TextureProgressBar = $TextureProgressBar


@export var hand_path: Path2D

@export var deck: Array[Ingredient]


var use_deck: Array[Ingredient]
var potion: Array[Ingredient]

func _ready() -> void:
	Game.player_start_turn.connect(player_start)
	Game.card_selected.connect(on_selected_cards)
	

	
func add_card(card_ing):
	#if cards.size() >= hand_size:
		#return
	var card = card_scene.instantiate()
	var card_path = path_scene.instantiate()
	card.ingredient = card_ing
	card.path = card_path
	card.path_pos_index = float(cards.size())
	add_child(card)
	hand_path.add_child(card_path)
	
	#remote path is a node that forces another to copy its transforms
	card_path.get_child(0).remote_path = card_path.get_child(0).get_path_to(card)
	card_path.set("position",Vector2(0,0))
	cards.append(card)
	use_deck.pop_at(0)
	_update_hand_layout()

func remove_card(card):
	card.path.queue_free()
	
	cards.erase(card)
	card.queue_free()
		
	_update_hand_layout()

func _update_hand_layout():
	var total = cards.size()
	if total == 0:
		Game.held_hand_modified.emit(cards)
		return
	for i in range(total):
		cards[i].move_to_position()
		
	card_order = []				#card array with cards and selected_cards, selected_cards coming first and removing duplicates
	for i in selected_cards+cards:
		if not card_order.has(i):
			card_order.append(i)
	for i in len(card_order):				#card selection based on order in node tree (end is better)
		move_child(card_order[i],-(i+1))		#reversing the order makes the top card the highest prior
	Game.held_hand_modified.emit(cards)
	

func on_selected_cards(card):
	if not selected_cards.has(card):
		selected_cards.append(card)
		card.card_sprite.material.set("shader_parameter/outline_color",Vector4(1, 0, 0,1))
		for i in cards:
			if i.path_pos_index < card.path_pos_index and not selected_cards.has(i):
				i.path_pos_index += 1.0
		card.path_pos_index = len(selected_cards)-1
		_update_hand_layout()
	else:
		selected_cards.erase(card)
		card.card_sprite.material.set("shader_parameter/outline_color",Vector4(1, 0, 0,0))
		for i in selected_cards:
			if i.path_pos_index > card.path_pos_index:
				i.path_pos_index -= 1
		card.path_pos_index = len(selected_cards)
		_update_hand_layout()

func _on_play_pressed() -> void:
	var played_cards = 0
	if has_potion:
		if Player.mana > 0:
			if selected_cards:
				for i in selected_cards:
					potion.append(i.ingredient)
					remove_card(i)
					Player.mana -= 1
					played_cards += 1
					for j in cards:
						j.path_pos_index -= 1.0
				draw(played_cards)

				selected_cards = []
	
	_update_hand_layout()
				
func _on_throw_pot_pressed() -> void:
	if Game.current_enemy:
		Game.current_enemy.take_potion(potion)
		potion = []
		has_potion = false

func _on_end_turn_pressed() -> void:
	has_potion = false
	Game.end_turn.emit()
	

func _on_throw_self_pressed() -> void:
	Player.take_potion(potion)
	potion = []
	has_potion = false

func _on_get_potion_pressed() -> void:
	if Player.mana > 0:
		if has_potion == false:
			Player.mana -= 1
			has_potion = true

func _process(_delta: float) -> void:
	mana_bar.value = Player.mana
	if potion_sprite:
		if has_potion:
			potion_sprite.visible = true
		else:
			potion_sprite.visible = false


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
	var cards_to_remove = cards.duplicate()
	for card in cards_to_remove:
		remove_card(card)
	
	_update_hand_layout()
	draw(5)
	_on_get_potion_pressed()
	selected_cards = []
