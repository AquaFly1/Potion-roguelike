extends Entity

@export var gold = 0
@export var level = 0
@export var xp = 0

@export var max_mana = 10
var mana = 10

@onready var info: Label = $info/Label
@onready var burn_label: Label = $poison/Label
@onready var poison_label: Label = $burn/Label
@onready var rejuv_label: Label = $rejuv/Label

@onready var panels: Control = $"."

var xp_needed = 10

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
