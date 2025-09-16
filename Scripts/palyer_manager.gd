extends Entity

@export var gold = 0
@export var level = 0
@export var xp = 0

@export var max_mana = 5
var mana = 5

@onready var info: Label# = $info			#g enleve pasque ca mettait des erreurs jsp ca sert a quoi
@onready var burn_label: Label# = $burn/Label
@onready var poison_label: Label# = $posion/Label
@onready var rejuv_label: Label# = $rejuv/Label


var xp_needed = 10

func start_turn():
	super()
	mana = max_mana
	Game.player_start_turn.emit()

func _process(_delta: float) -> void:
	if xp >= xp_needed:
		xp -= xp_needed
		xp_needed *= 2
		level += 1
	if info:
		info.text = "health: %d gold: %d xp: %d level: %d " % [Player.health, Player.gold, Player.xp, Player.level]
	if burn_label and poison_label and rejuv_label:
		burn_label.text = str(Player.burn)
		poison_label.text = str(Player.poison)
		rejuv_label.text = str(Player.rejuv)
