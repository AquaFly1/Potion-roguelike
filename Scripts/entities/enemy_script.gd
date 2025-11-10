extends Entity

class_name Enemy

@export var sprite_texture: Texture

#@onready var entity_sprite: Sprite2D = $Sprite2D
@onready var sprite: Sprite3D = $Enemy_sprite

var test_node: Node2D

@export var gold_range: Array[int]
@export var xp_given = 0

var chosen_potion = null
@export var potions: Array[Potion]

@onready var gui_origin: Marker3D = $gui_origin
@onready var gui_parent: Control = $Effects

@onready var fire_visuals : Sprite2D = $VFX/SubViewport/Fire
@onready var poison_visuals : GPUParticles2D = $VFX/SubViewport/PoisonBubble

var preparing: int = 1
#@onready var attack_button: Marker3D = $attack_origin

func _ready() -> void:
	super()
	sprite.material_overlay = sprite.material_overlay.duplicate(true)
	sprite.material_overlay.set("sprite_texture",sprite_texture)
	
	chosen_potion = potions.pick_random()
	

func start_turn():
	outline(Color.WHITE)
	await super.start_turn()
	
	if not is_queued_for_deletion(): 
		while chosen_potion.drink == true and health == max_health: chosen_potion = potions.pick_random()
		if chosen_potion.drink == true:
			await PotionMan.throw_potion(chosen_potion.ingredients, rings, self, true)
			sprite.modulate = Color(1.0, 1.0, 1.0, 1.0)
			chosen_potion = potions.pick_random()
			preparing = 1
			
		else:
			if preparing != 0:
				sprite.modulate = Color(0.813, 0.0, 0.092, 1.0)
				preparing -= 1
			else:
				await PotionMan.throw_potion(chosen_potion.ingredients, rings, Player)
				sprite.modulate = Color(1.0, 1.0, 1.0, 1.0)
				chosen_potion = potions.pick_random()
				preparing = 1
	
	await end_turn()

func end_turn():
	
	await super()
	clear_outline()
	


func update_effect_vfx(effect: Effect):
	match effect.name:
		"Burn":
			fire_visuals.visible = effects[Effect.index(effect.name)] 
		"Poison":
			poison_visuals.visible = effects[Effect.index(effect.name)] 
		_:
			pass

func outline(color = null) -> Color:
	if color: 
		sprite.material_overlay.set("shader_parameter/glowSize",  int(color != Color.TRANSPARENT))
		sprite.material_overlay.set("shader_parameter/line_color",color)
	else: color = sprite.material_overlay.get("shader_parameter/line_color")
	return color
	

func clear_outline(): outline(Color.TRANSPARENT)

func _process(delta: float) -> void:
	super(delta)
	gui_parent.visible = not get_viewport().get_camera_3d().is_position_behind(gui_origin.global_position)
	gui_parent.position = get_viewport().get_camera_3d().unproject_position(gui_origin.global_position)

#	if chosen_potion and intention:
#		intention.text = ("This enemy \nintends to \n" + str(chosen_potion.intention) + ".")

func _on_button_pressed() -> void:
	Game.current_enemy = self

func die():
	Player.gold += randi_range(gold_range[0], gold_range[1])
	Game.xp_end_of_fight += xp_given
	
	
	await get_tree().create_timer(0.5).timeout
	
	while Game.enemy_list.has(self):
		Game.enemy_list.erase(self)
	
	Game.enemy_killed.emit()
	
	queue_free()
	


func _on_button_mouse_entered() -> void:
	Game.current_enemy = self
