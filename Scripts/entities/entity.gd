extends Node

class_name Entity

@export var max_health: int = 0

var health = StatPool.new()

var burn = StatPool.new()
var poison = StatPool.new()
var rejuv = StatPool.new()

func take_potion(potion):
	var damages = Game.apply_potion(potion)
	health.decrease(damages[0])
	burn.decrease(damages[1])
	poison.decrease(damages[2])
	rejuv.decrease(damages[3])
	health.increase(damages[4])

func _ready() -> void:
	health.min_value = 0
	health.max_value = max_health
	health.value = max_health
	
	health.value_changed.connect(_on_health_changed)
	health.depleted.connect(_on_entity_died)

func start_turn():
	health.decrease(burn.value)
	burn.value = 0

	if poison.value > 0:
		health.decrease(1)
		poison.decrease(1)

	if rejuv.value > 0:
		health.increase(1)
		rejuv.decrease(1)

func _on_health_changed():
	pass

func _on_entity_died():
	pass

func _process(_delta: float) -> void:
	pass
