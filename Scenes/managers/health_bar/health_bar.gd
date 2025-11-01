extends Control

@onready var health: ColorRect = $Health
@onready var burn: ColorRect = $Burn
@onready var poison: ColorRect = $Poison
@onready var rejuv: ColorRect = $Rejuv
@onready var shield: ColorRect = $Shield

@export var entity: Entity

var test = [25.0, 10.0, 3.0, 2.0, 1.0, 3.0]

var max_size: float

func _ready() -> void:
	max_size = health.size.x

func _process(_delta: float) -> void:
#	health.size.x = (entity.health/entity.max_health) * max_size
#	burn.size.x = (entity.effects[1]/entity.max_health) * max_size
#	burn.position.x = health.position.x + health.size.x - burn.size.x
	
	health.size.x = test[1]/test[0] * max_size
	burn.size.x = test[2]/test[0] * max_size
	burn.position.x = health.position.x + health.size.x - burn.size.x
	poison.size.x = test[3]/test[0] * max_size
	poison.position.x = burn.position.x - poison.size.x
	rejuv.size.x = test[4]/test[0] * max_size
	burn.position.x = health.position.x + health.size.x
