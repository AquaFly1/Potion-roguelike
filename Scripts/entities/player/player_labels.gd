extends Control


@onready var info: Label = $Info_bg/Info_label


func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	if self:
		if Game.is_in_combat:
			self.visible = true
		else:
			self.visible = false
	if info:
		info.text = "health: %d gold: %d \nxp: %d level: %d \ndamage: %d " % [Player.health, Player.gold, Player.xp, Player.level, Player.effects[0]]
