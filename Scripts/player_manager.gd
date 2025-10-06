extends Entity

@export var gold = 0
@export var level = 0
@export var xp = 0

@export var max_mana = 10
var mana = 10

var info
var burn_label
var poison_label
var rejuv_label

var panels

var player_manager_node: Control

var xp_needed = 10

func _ready() -> void:
	print(self)
	if self == Control:
		player_manager_node = $"."
	else:
		player_manager_node = find_child("player_manager",true)
	print($".")
	#info = player_manager_node.get_node("./info/Label")
	#burn_label = player_manager_node.get_node("./burn/Label")
	info = $burn/Label
	burn_label = $rejuv/Label
	poison_label = $burn/Label
	rejuv_label = $rejuv/Label
	panels = $"."


func start_turn():
	super()
	mana = max_mana
	Game.player_start_turn.emit()

func _process(_delta: float) -> void:
	if panels:
		if Game.is_in_combat:
			panels.visible = true
		else:
			panels.visible = false
	if xp >= xp_needed:
		xp -= xp_needed
		xp_needed *= 2
		level += 1
	if info:
		info.text = "health: %d gold: %d \nxp: %d level: %d " % [Player.health, Player.gold, Player.xp, Player.level]
	if burn_label and poison_label and rejuv_label:
		burn_label.text = str(Player.burn)
		poison_label.text = str(Player.poison)
		rejuv_label.text = str(Player.rejuv)
