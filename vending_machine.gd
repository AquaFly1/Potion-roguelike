extends Control

@onready var input_label: Label = $buttons/Input
var packs = []
var tween: Tween
@onready var pack_container: GridContainer = $pack_container
@onready var player_money: Label = $player_money

var input: String

func _ready() -> void:
	player_money.text = str(Player.gold)
	for child in pack_container.get_children():
		packs.append(child)
	tween = create_tween()
	tween.tween_interval(0)

func input_button(key: String):
	if len(input) < 3 and not tween.is_running():
		input += key
		update_text()

func update_text():
	input_label.text = input
	if len(input) == 3:
		for pack in packs:
			if pack.pack_position == input:
				pack.purchase()
				packs.erase(pack)
				update_money_label()
				
			
		tween = create_tween()
		tween.tween_interval(0.5)
		await tween.finished
		input = ""
		input_label.text = input
		
func update_money_label():
	player_money.text = str(Player.gold)
