extends Control

@export var chand_size: int = 5
@export var card_spacing: float = 100.0

@export var card_scene: PackedScene
@export var path_scene: PackedScene
@export var hand_anim: AnimationTree
@export var cards_parent: Node

var mouse_on_potion: bool = false
var is_dragging: bool = false

var was_on_pot: bool = false

var selected_cards: Array[Card]
var cards: Array[Card]
var card_order: Array[Card] #card order for making sure we click the right card



var test_node: Node2D

@onready var mana_bar: TextureProgressBar = $Mana_bar


@export var chand_path: Path2D

var has_potion = false
var use_deck: Array[Ingredient]
var potion: Array[Ingredient] = []




func _ready() -> void:
	Game.player_start_turn.connect(player_start)
	Game.interaction_ended.connect(interaction_end)
	Game.card_selected.connect(on_selected_cards)
	Game.card_pressed.connect(on_card_pressed)
	
	
	

	
func add_card(card_ing):
	#if cards.size() >= chand_size:
		#return
	var card = card_scene.instantiate()
	var card_path = path_scene.instantiate()
	card.ingredient = card_ing
	card.path = card_path
	card.path_pos_index = float(cards.size())
	cards_parent.add_child(card)
	chand_path.add_child(card_path)
	
	#remote path is a node that forces another to copy its transforms
	card_path.get_child(0).remote_path = card_path.get_child(0).get_path_to(card)
	card_path.set("position",Vector2(0,0))
	cards.append(card)
	use_deck.pop_at(0)
	_update_chand_layout()

func remove_card(card):
	card.path.queue_free()
	
	selected_cards.erase(card)
	cards.erase(card)
	card.queue_free()
	
	_update_chand_layout()

func _update_chand_layout():
	var total = cards.size()
	if total != 0:
		for i in range(total):
			cards[i].move_to_position()
			
		card_order = []				#card array with cards and selected_cards, selected_cards coming first and removing duplicates
		
		for i in selected_cards+cards:
			if not card_order.has(i):
				card_order.append(i)
		cards = card_order # cards list now in order
		for i in len(card_order):			#card selection based on order in node tree (end is better)
			cards_parent.move_child(card_order[i],-(i+1))		#reversing the order makes the top card the highest prior
	
	hand_anim.update_hand_size(total)
	Game.held_chand_modified.emit(cards)
	

func on_selected_cards(card):
	if not selected_cards.has(card):
		if len(selected_cards) < Player.mana:
			selected_cards.append(card)
			card.card_sprite.material.set("shader_parameter/outline_color",Vector4(1, 0, 0,1))

			for i in cards:
				if i.path_pos_index < card.path_pos_index and not selected_cards.has(i):
					i.path_pos_index += 1.0
			card.path_pos_index = len(selected_cards)-1
			_update_chand_layout()
	else:
		selected_cards.erase(card)
		card.card_sprite.material.set("shader_parameter/outline_color",Vector4(1, 0, 0,0))
		for i in selected_cards:
			if i.path_pos_index > card.path_pos_index:
				i.path_pos_index -= 1
		card.path_pos_index = len(selected_cards)
		_update_chand_layout()

func on_card_pressed(_card: Card):
	if _card in selected_cards:
		is_dragging = true

				
func _on_throw_pot_pressed() -> void:
	if Game.current_enemy and has_potion:
		has_potion = false
		await PotionMan.throw_potion(potion, Player.rings, Game.current_enemy)
		potion = []
		Game.current_enemy = null
		
		if Player.mana <= 0: Player.turn_ended.emit()
		else: 
			_on_get_potion_pressed()
			hand_anim.play()
			draw(chand_size-len(cards))

func _on_throw_self_pressed() -> void:
	if has_potion:
		has_potion = false
		await PotionMan.throw_potion(potion, Player.rings, Player, true)
		potion = []
		
		if Player.mana <= 0: Player.turn_ended.emit()
		else: 
			_on_get_potion_pressed()
			hand_anim.play()
			draw(chand_size-len(cards))

func _on_get_potion_pressed() -> void:
	if Player.mana > 0:
		if has_potion == false:
			Player.mana -= 1
			has_potion = true

func _process(_delta: float) -> void:
	mana_bar.value = Player.mana


func _on_draw_pressed() -> void:
	draw(1)

func draw(amount: int):
	for i in amount:
		if use_deck != []:
			add_card(use_deck[0])
	_update_chand_layout()

func player_start():
	$"../Crosshair".visible = false
	Player.mana = Player.max_mana
	Game.deck.shuffle()
	use_deck = Game.deck.duplicate(true)
	var cards_to_remove = cards.duplicate()
	for card in cards_to_remove:
		remove_card(card)
	
	hand_anim.play()
	_update_chand_layout()
	draw(5)
	_on_get_potion_pressed()
	selected_cards = []

func interaction_end():
	$"../Crosshair".visible = true
	for card in cards.duplicate():
		remove_card(card)


func _on_potion_mouse_entered() -> void:
	mouse_on_potion = true

func _on_potion_mouse_exited() -> void:
	mouse_on_potion = false



func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if not event.is_pressed():
				if is_dragging:
					if mouse_on_potion:
						play_selected_cards()
					else:
						is_dragging = false
func play_selected_cards():
	#var played_cards = 0
	if has_potion and Player.mana > 0 and selected_cards:
		for i in selected_cards.duplicate():
			potion.append(i.ingredient)
			remove_card(i)
			Player.mana -= 1
			#played_cards += 1
			for j in cards:
				j.path_pos_index -= 1.0
		#draw(played_cards)
		selected_cards = []
	_update_chand_layout()


func _on_potion_button_down() -> void:
	was_on_pot = true

func _on_potion_button_up() -> void:
	was_on_pot = false
