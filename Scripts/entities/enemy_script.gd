extends Entity

class_name Enemy

@export var sprite_frames: SpriteFrames

#@onready var entity_sprite: Sprite2D = $Sprite2D
@onready var sprite_node: AnimatedSprite3D = $Enemy_sprite

var test_node: Node2D

@export var gold_range: Array[int]
@export var xp_given = 0

var chosen_potion = null
@export var potions: Array[Potion]

@onready var gui_origin: Marker3D = $Enemy_sprite/gui_origin
@onready var gui_parent: Control = $Effects
@onready var attack_origin: Marker3D = $Enemy_sprite/attack_origin
@onready var attack_parent: Control = $Target

@export_group("VFX")
@onready var base_color := sprite_node.modulate
@export var fire_origin : Node3D
@export var fire_visuals : AnimatedSprite3D
@export var fire_light: OmniLight3D
@onready var fire_outline: ShaderMaterial
@export var poison_visuals : GPUParticles2D

var ice_outline: ShaderMaterial


var preparing: int = 1


func _ready() -> void:
	super()
	sprite_node.pixel_size *= self.scale.y 
	sprite_node.scale = Vector3.ONE/self.scale.y	#or else overlays fucked
	
	sprite_node.material_overlay = sprite_node.material_overlay.duplicate(true)
	sprite_node.material_overlay.set("sprite_frames",sprite_frames)
	
	fire_outline = sprite_node.material_overlay.next_pass
	ice_outline = fire_outline.next_pass
	gui_parent.visible = false
	
	attack_parent.visible = false
	fire_origin.scale = Vector3.ZERO
	fire_light.light_energy = 0
	chosen_potion = potions.pick_random()
	Game.interaction_started.connect(interaction_start)
	Game.enemy_selected_signal.connect(on_selected_enemy_update)
	
func interaction_start() -> void:
	gui_parent.visible = true
	attack_parent.visible = true
	sprite_node.set_layer_mask_value(1,false)
	sprite_node.set_layer_mask_value(13,true)

func get_size() -> Vector2:
	return sprite_node.scale.x * sprite_node.pixel_size * sprite_node.sprite_frames.get_frame_texture(sprite_node.animation,sprite_node.frame).get_size()
	#returns the size of the current sprite frame in world coords

func start_turn():
	outline(Color.YELLOW)
	await super.start_turn()
	if not frozen:
		if not is_queued_for_deletion(): 
			while chosen_potion.drink == true and health == max_health: chosen_potion = potions.pick_random()
			if chosen_potion.drink == true:
				await PotionMan.throw_potion(chosen_potion.ingredients, rings, self, true)
				sprite_node.modulate = Color(1.0, 1.0, 1.0, 1.0) * base_color
				chosen_potion = potions.pick_random()
				preparing = 1
				
			else:
				if preparing != 0:
					sprite_node.modulate = Color(1.0, 0.51, 0.49, 1.0) * base_color
					preparing -= 1
				else:
					await PotionMan.throw_potion(chosen_potion.ingredients, rings, Player)
					sprite_node.modulate = Color(1.0, 1.0, 1.0, 1.0) * base_color
					chosen_potion = potions.pick_random()
					preparing = 1
	
	await end_turn()

func end_turn():
	
	await super()
	outline(Color.TRANSPARENT)
	


func update_effect_vfx(effect: Effect, do_damage_effect = false):	##since damage is called by the entity when it loses health
	var intensity := effects[Effect.index(effect.name)] 
	var fx_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	fx_tween.tween_interval(0)
	fx_tween.set_parallel()
	match effect.name:
		"Damage":
			if do_damage_effect:
				var prev_sprite_color = sprite_node.modulate
				var prev_outline_color = outline()
				sprite_node.modulate = Color.RED
				fx_tween.set_trans(Tween.TRANS_QUAD)
				fx_tween.tween_property(sprite_node,"modulate",prev_sprite_color,max(intensity*4./max_health,1.))
				fx_tween.tween_method(outline,Color.RED,prev_outline_color,max(intensity*4./max_health,1.))
		"Burn":
			fx_tween.tween_method(
				func(x): fire_outline.set_shader_parameter("intensity", x), 
				fire_outline.get_shader_parameter("intensity"),
				min(intensity*1.2/max_health,1),
				1.5)
			fx_tween.tween_property(fire_origin,"scale",(intensity>=max_health as int) * Vector3.ONE,0.5)
			fx_tween.tween_property(fire_light,"light_energy",intensity/(2*max_health+20),0.5)
		"Poison":
			poison_visuals.amount_ratio = intensity/ poison_visuals.amount
			poison_visuals.emitting = intensity
			poison_visuals.get_child(0).emitting = intensity
		
		"Freeze":
			fx_tween.tween_method(
				func(x): ice_outline.set_shader_parameter("intensity", x), 
				ice_outline.get_shader_parameter("intensity"),
				min(intensity*0.5,1),
				1.5)
		_:
			pass

func pause_animations(value:bool):
	if value: sprite_node.pause()
	else: sprite_node.play()

var hovering: bool
func update_hover(active:bool):
	sprite_node.material_overlay.set("shader_parameter/hovering", active)
	sprite_node.material_overlay.set("shader_parameter/hovering_time_offset", Time.get_ticks_msec()/1000.)

var selected:	bool = false
func clicked(_camera: Node, event: InputEvent, _event_position: Vector3 = Vector3.ZERO, _normal: Vector3 = Vector3.ZERO, _shape_idx: int = 0):
	if event.is_action_pressed("click"):
		selected = not selected
		Game.current_enemy = self if selected else null
		if not selected:	sprite_node.material_overlay.set("shader_parameter/hovering_time_offset", Time.get_ticks_msec()/1000.)
		sprite_node.material_overlay.set("shader_parameter/selected", selected)

func on_selected_enemy_update(enemy):
	if self != enemy: 
		selected = false
		sprite_node.material_overlay.set("shader_parameter/selected", false)
		sprite_node.material_overlay.set("shader_parameter/hovering_time_offset", Time.get_ticks_msec()/1000.)

func outline(color = null) -> Color:
	if color:
		sprite_node.material_overlay.set("shader_parameter/opacity",  color.a)
		sprite_node.material_overlay.set("shader_parameter/line_color",color)
	return sprite_node.material_overlay.get("shader_parameter/line_color")

func _process(delta: float) -> void:
	super(delta)
	if Game.is_in_combat:
		gui_parent.visible = not get_viewport().get_camera_3d().is_position_behind(gui_origin.global_position)
		attack_parent.visible = gui_parent.visible
		gui_parent.position = get_viewport().get_camera_3d().unproject_position(gui_origin.global_position)
		attack_parent.position = get_viewport().get_camera_3d().unproject_position(attack_origin.global_position)


func _on_button_pressed() -> void:
	Game.current_enemy = self

func die():
	Player.gold += randi_range(gold_range[0], gold_range[1])
	Game.xp_end_of_fight += xp_given
	
	
	
	await get_tree().create_timer(0.5).timeout
	
	finished_afflicting.emit()
	
	while Game.enemy_list.has(self):
		Game.enemy_list.erase(self)
	
	Game.enemy_killed.emit()
	
	
	queue_free()
	


func _on_button_mouse_entered() -> void:
	Game.current_enemy = self
