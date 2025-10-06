extends Entity

class_name Enemy

@export var sprite: Texture

#@onready var entity_sprite: Sprite2D = $Sprite2D

@export var gold_range: Array[int]
@export var xp_given = 0

var chosen_potion = null
@export var potions: Array[Potion]

@onready var burn_label: Label = $Effects/Burn/Burn_label
@onready var poison_label: Label = $Effects/Poison/Poison_label
@onready var rejuv_label: Label = $Effects/Rejuvination/Rejuvination_label
@onready var health_label: Label = $Effects/Health/Health_label

@onready var info_panel: Panel = $info_panel
@onready var potion_name: Label = $info_panel/potion_name


func _ready() -> void:
#	entity_sprite.texture = sprite
	chosen_potion = potions.pick_random()

func _on_entity_died():
	Player.gold += randi_range(gold_range[0], gold_range[1])
	Game.xp_end_of_fight += xp_given
	self.queue_free()

func start_turn():
	super()
	
	#animation
	
	var chosen_potion_ingredients = chosen_potion.ingredients
	
	if chosen_potion.heal == true:
		self.take_potion(chosen_potion_ingredients)
	else:
		Player.take_potion(chosen_potion_ingredients)
	chosen_potion = potions.pick_random()



func _process(delta: float) -> void:
	super(delta)
	burn_label.text = str(burn)
	poison_label.text = str(poison)
	rejuv_label.text = str(rejuv)
	health_label.text = str(health)
	if chosen_potion:
		potion_name.text = ("This enemy \nintends to \n" + str(chosen_potion.intention) + ".")
		

func _on_button_pressed() -> void:
	Game.current_enemy = self


func _on_button_mouse_entered() -> void:
	info_panel.scale = Vector2(1,1)


func _on_button_mouse_exited() -> void:
	info_panel.scale = Vector2(0,0)
