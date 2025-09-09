extends Entity

class_name Enemy

@export var sprite: Texture

@onready var entity_sprite: Sprite2D = $Sprite2D

@export var gold_range: Array[int]
@export var xp_given = 0

@export var potions: Array[Potion]

@onready var burn_label: Label = $burn/Label
@onready var poison_label: Label = $posion/Label
@onready var rejuv_label: Label = $rejuv/Label
@onready var health_label: Label = $health/Label

func _ready() -> void:
	entity_sprite.texture = sprite

func die():
	Player.gold += randi_range(gold_range[0], gold_range[1])
	Player.xp += xp_given
	self.queue_free()

func start_turn():
	super()
	var chosen_potion = potions.pick_random()
	#animation
	var potion_ingredients = chosen_potion.ingredients
	Player.take_potion(potion_ingredients)



func _process(delta: float) -> void:
	burn_label.text = str(burn)
	poison_label.text = str(poison)
	rejuv_label.text = str(rejuv)
	health_label.text = str(health)

func _on_button_pressed() -> void:
	Game.current_enemy = self
