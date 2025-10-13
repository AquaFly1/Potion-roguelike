extends Control

@onready var info: Label = $Info_bg/Info_label
@onready var poison_label: Label = $Poison_bg/Poison_label
@onready var burn_label: Label = $Burn_bg/Burn_label
@onready var rejuv_label: Label = $Rejuvination_bg/Rejuvination_label

func _process(_delta: float) -> void:
	if self:
		if Game.is_in_combat:
			self.visible = true
		else:
			self.visible = false
	if info:
		info.text = "health: %d gold: %d \nxp: %d level: %d " % [Player.health.value, Player.gold, Player.xp, Player.level]
	if burn_label and poison_label and rejuv_label:
		burn_label.text = str(Player.burn.value)
		poison_label.text = str(Player.poison.value)
		rejuv_label.text = str(Player.rejuv.value)
