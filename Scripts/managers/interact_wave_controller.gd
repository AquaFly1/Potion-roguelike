extends ColorRect

func _ready() -> void:
	Game.interaction_started.connect(start_wave)
	Game.interaction_ended.connect(end_wave)
	
func start_wave():
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self.material,"shader_parameter/intensity",1,1)
	
func end_wave():
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self.material,"shader_parameter/intensity",0,1)
