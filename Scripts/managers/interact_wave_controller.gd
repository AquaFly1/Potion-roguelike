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
	tween.tween_property(self.material,"shader_parameter/intensity",1,1)
	
	tween.tween_method(set_shader_value.bind(warp_filter.material,"intensity"),0.0,0.5,2)
	
	
	save_cam_env()
	tween_adjustments(battle_curves,1,0.5)
	
	
	
func end_wave():
	tween = create_tween().set_ease(Tween.EASE_IN_OUT)
	
	tween.tween_property(self.material,"shader_parameter/intensity",0,1)
	tween_adjustments(battle_curves,1,0.5)

func save_cam_env():
	camera_env = Player.node.camera.environment

func tween_adjustments(env, amount:float, warp_amount: float = amount):
	for i in ["adjustment_brightness","adjustment_saturation","adjustment_contrast"]:
		tween.tween_property(Player.node.camera.environment,i,
			(env.get(i)-camera_env.get(i))*amount + camera_env.get(i)
			,1)
	tween.tween_method(set_shader_value.bind(warp_filter.material,"intensity"),
		warp_filter.material.get_shader_parameter("intensity"),
		warp_amount,1)

func set_shader_value(value, mat: ShaderMaterial, target: String):
	mat.set_shader_parameter(target,value)
