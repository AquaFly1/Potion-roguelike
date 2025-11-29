extends Node

class_name Entity

@export var rings: Array[Ring]
@export var max_health: float = 10


@onready var effects: Array[float]

var health_bar : Control

var health: float = 0

var frozen:=false:
	set(value):
		frozen = value
		pause_animations(value)

signal finished_afflicting #for potionmanager throwing a potion, if it dies before all aflicted await fuck up

func _ready() -> void:
	effects.resize(Game.effects.size()) #have to use Game 
	effects.fill(0.0)
	health = max_health


func take_damage(amount):
	await Effect.call_event(self,Effect.ON_DAMAGE)
	
	await update_effect_vfx(Effect.effects[Effect.index("Damage")],true)
	
	health -= amount
	
	await Effect.call_event(self,Effect.AFTER_DAMAGE)
	

func start_turn():
	health_bar.anim_text.text = "Starting turn"
	await Effect.call_event(self, Effect.START_TURN)
	await Ring.call_event(self, Ring.START_TURN)
	await get_tree().create_timer(0.5).timeout
		
	return effects[Effect.index("Freeze")] == 0
	
func end_turn():
	health_bar.anim_text.text = "Ending turn"
	
	await Effect.call_event(self, Effect.END_TURN)
	await Ring.call_event(self, Ring.END_TURN)
	await get_tree().create_timer(0.5).timeout
	
	
	
func update_effect_vfx(_effect,_do_damage_effect = false):
	pass

func pause_animations(_value:bool):
	pass

func _process(_delta: float) -> void:
	pass

func die():
	pass
	
