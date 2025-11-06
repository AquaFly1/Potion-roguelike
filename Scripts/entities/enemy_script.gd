extends Entity

class_name Enemy

@export var sprite: Texture

#@onready var entity_sprite: Sprite2D = $Sprite2D
@onready var enemy_sprite: Sprite3D = $Enemy_sprite

var test_node: Node2D

@export var gold_range: Array[int]
@export var xp_given = 0

var chosen_potion = null
@export var potions: Array[Potion]

@onready var burn_label: Label = $Effects/Burn_icon/Burn_label
@onready var poison_label: Label = $Effects/Poison_icon/Poison_label
@onready var rejuv_label: Label = $Effects/Rejuvination_icon/Rejuvination_label
@onready var health_label: Label = $Effects/Health_icon/Health_label
@onready var gui_origin: Marker3D = $gui_origin
@onready var gui_parent: Control = $Effects
var preparing: int = 1
#@onready var attack_button: Marker3D = $attack_origin

func _ready() -> void:
	super()
	enemy_sprite.texture = sprite
	
	chosen_potion = potions.pick_random()

func start_turn():
	
	await super.start_turn()
	if not is_queued_for_deletion(): 
		while chosen_potion.drink == true and health == max_health: chosen_potion = potions.pick_random()
		if chosen_potion.drink == true:
			await PotionMan.throw_potion(chosen_potion.ingredients, rings, self, true)
			enemy_sprite.modulate = Color(1.0, 1.0, 1.0, 1.0)
			chosen_potion = potions.pick_random()
			preparing = 1
			
		else:
			if preparing != 0:
				enemy_sprite.modulate = Color(0.813, 0.0, 0.092, 1.0)
				preparing -= 1
			else:
				await PotionMan.throw_potion(chosen_potion.ingredients, rings, Player)
				enemy_sprite.modulate = Color(1.0, 1.0, 1.0, 1.0)
				chosen_potion = potions.pick_random()
				preparing = 1
		


func _process(delta: float) -> void:
	super(delta)
#	info_panel.position = Game.camera.unproject_position(info_but_pos)
	gui_parent.visible = not get_viewport().get_camera_3d().is_position_behind(gui_origin.global_position)
	gui_parent.position = get_viewport().get_camera_3d().unproject_position(gui_origin.global_position)
	


	burn_label.text = str(effects[1])
	poison_label.text = str(effects[2])
	rejuv_label.text = str(effects[3])
	health_label.text = str(health)
#	if chosen_potion and intention:
#		intention.text = ("This enemy \nintends to \n" + str(chosen_potion.intention) + ".")

func _on_button_pressed() -> void:
	Game.current_enemy = self

func die():
	Player.gold += randi_range(gold_range[0], gold_range[1])
	Game.xp_end_of_fight += xp_given
	
	while Game.enemy_list.has(self):
		Game.enemy_list.erase(self)
	
	queue_free()
	
