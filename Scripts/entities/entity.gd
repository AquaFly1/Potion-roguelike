extends Node

class_name Entity

@export var rings: Array[Ring]
@export var max_health: float = 10


@onready var effects: Array[float]

var health: float = 0


func _ready() -> void:
	effects.resize(Game.effects.size()) #have to use Game 
	effects.fill(0.0)
	health = max_health

func take_damage(amount):
	var dmg = amount
	amount -= effects[4]

	effects[4] -= max(dmg,0)

	health -= amount
	effects[0] = 0

func start_turn():
	await Effect.call_event(self, Effect.START_TURN)
	await Ring.call_event(self, Ring.START_TURN)
	await get_tree().create_timer(0.5).timeout
	if health <= 0:
		await die() 
	
func end_turn():
	
	await get_tree().create_timer(0.4).timeout
	
	await Effect.call_event(self, Effect.END_TURN)
	await Ring.call_event(self, Ring.END_TURN)
	
	await get_tree().create_timer(0.5).timeout
	
	if health <= 0:
		await die() 
	

func _process(_delta: float) -> void:
	#if health:
		#if health <= 0:
			#die()
	#if health > max_health:
		#health = max_health
	pass

func die():
	pass
