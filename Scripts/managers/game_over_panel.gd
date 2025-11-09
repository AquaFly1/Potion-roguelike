extends Panel


func _ready() -> void:
	Player.death.connect(game_over)
	
func game_over():
	visible = true
