extends ColorRect

@export var battle_curves: Environment
@export var warp_filter: TextureRect

func _ready() -> void:
	Game.interaction_started.connect(start_wave)
	Game.interaction_ended.connect(end_wave)
	
func start_wave():
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_parallel()
	tween.tween_property(self.material,"shader_parameter/intensity",1,1)
	
	tween.tween_method(set_shader_value.bind(warp_filter.material,"intensity"),0.0,0.5,2)
	
	
	for i in ["adjustment_brightness","adjustment_saturation"]:
		
		tween.tween_property(Player.node.camera.environment,i,battle_curves.get(i),1)
	
	
func end_wave():
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT)
	
	tween.tween_property(self.material,"shader_parameter/intensity",0,1)
	tween.tween_method(set_shader_value.bind(warp_filter.material,"intensity"),0.5,0.0,2)


func set_shader_value(value, mat: ShaderMaterial, target: String):
	mat.set_shader_parameter(target,value)
