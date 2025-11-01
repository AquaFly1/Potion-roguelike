extends Control

@onready var health: ColorRect = $Health
@onready var burn: ColorRect = $Burn
@onready var poison: ColorRect = $Poison
@onready var rejuv: ColorRect = $Rejuv
@onready var shield: ColorRect = $Shield

var entity: Entity

var max_size: float

func _ready() -> void:
	max_size = health.size.x
	entity = get_parent().get_parent()

func _process(_delta: float) -> void:
	health.size.x = (entity.health/entity.max_health) * max_size
	burn.size.x = (entity.effects[1]/entity.max_health) * max_size
	burn.position.x = health.position.x + health.size.x - burn.size.x
	poison.size.x = entity.effects[2]/entity.max_health * max_size
	poison.position.x = burn.position.x - poison.size.x
	rejuv.size.x = entity.effects[3]/entity.max_health * max_size
	rejuv.position.x = health.position.x + health.size.x
	shield.size.x = entity.effects[4]/entity.max_health * max_size
	
	
