extends DirectionalLight3D

var tween: Tween

func _ready() -> void:
	Game.interaction_started.connect(on)
	Game.interaction_ended.connect(off)
func on():
	tween = create_tween().set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self,"light_energy",1,0.5)
	
func off():
	tween = create_tween().set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self,"light_energy",0,0.5)
	
