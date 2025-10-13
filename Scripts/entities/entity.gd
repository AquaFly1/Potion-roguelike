extends Node

class_name Entity

@export var max_health = 10

var health = StatPool.new()

var burn = 0
var poison = 0
var rejuv = 0

func take_potion(potion):
	var damages = Game.apply_potion(potion)
	health.decrease(damages[0])
	burn += damages[1]
	poison += damages[2]
	rejuv += damages[3]
	health.increase(damages[4])

func _ready() -> void:
	health.min_value = 0
	health.max_value = max_health
	health.value = health.max_value
	
	health.value_changed.connect(_on_health_changed)
	health.depleted.connect(_on_entity_died)

func start_turn():
	health.decrease(burn)
	burn = 0

	if poison > 0:
		health.decrease(1)
		poison -= 1

	if rejuv > 0:
		health.increase(1)
		rejuv -= 1

func _on_health_changed():
	pass

func _on_entity_died():
	pass

func _process(_delta: float) -> void:
	pass
