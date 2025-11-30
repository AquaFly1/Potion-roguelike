extends ColorRect

@export var battle_curves: Environment
@export var warp_filter: TextureRect
var tween
var camera_env: Environment

func _ready() -> void:
	Game.interaction_started.connect(start_wave)
	Game.interaction_ended.connect(end_wave)
	
	
func enemy_power_changed():
	pass


func start_wave():
	tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_parallel()
	#tween.tween_property(self.material,"shader_parameter/intensity",1,1)
	tween.tween_property(warp_filter.material,"shader_parameter/intensity",3,0.5)
	tween_adjustments(battle_curves,0.1)
	
	
	
func end_wave():
	tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_parallel()
	
	tween.tween_property(self.material,"shader_parameter/intensity",0,1)
	tween.tween_property(warp_filter.material,"shader_parameter/intensity",0,0.5)
	tween_adjustments(battle_curves,0)


func tween_adjustments(env, amount:float):
	for i in ["adjustment_brightness","adjustment_saturation","adjustment_contrast"]:
		tween.tween_property(Player.node.camera.environment,i,
			(env.get(i)-Player.node.camera.camera_base_env.get(i))*amount + Player.node.camera.camera_base_env.get(i)
			,1)

func set_shader_value(value, mat: ShaderMaterial, target: String):
	mat.set_shader_parameter(target,value)
