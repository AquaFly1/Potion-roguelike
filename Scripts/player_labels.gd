extends Control


@onready var info: Label = $info/Label
@onready var poison_label: Label = $poison/Label
@onready var burn_label: Label = $burn/Label
@onready var rejuv_label: Label = $rejuv/Label


func _process(_delta: float) -> void:
	if self:
		if Game.is_in_combat:
			self.visible = true
		else:
			self.visible = false
	if info:
		info.text = "health: %d gold: %d \nxp: %d level: %d " % [Player.health, Player.gold, Player.xp, Player.level]
	if burn_label and poison_label and rejuv_label:
		burn_label.text = str(Player.burn)
		poison_label.text = str(Player.poison)
		rejuv_label.text = str(Player.rejuv)
