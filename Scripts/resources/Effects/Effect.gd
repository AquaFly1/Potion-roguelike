extends Resource

class_name Effect

@export var name: String
@export_multiline var description: String

##The  [param array]  of valid effects, used by the  [member Effects]  class and all  [member effects] insatnces. 
static var effects: Array[Effect]

##The name of the effect events callable with call_event(entity, Effect.EVENT).
##[br]Functionally just redefined ints.
enum {
	START_TURN,
	END_TURN,
	ON_DAMAGE,
	ON_HIT
}


##Defines the  [param array]  of valid effects, used by the  [member Effects]  class and all  [member effects] insatnces. 
##This should be called once by  [member GameManager]. 
##[br]Use  [code]Effect.get_effects()[/code]  to read this array.
static func define_effects(array):
	effects = array
	
##Returns the array of all valid  [member effects], in order. 
##[br]Use [code]Effect.find(name)[/code] to find the index of an [member effect].
static func get_effects():
	return effects.duplicate()

##Returns the size of the valid [member effects] array
static func get_length():
	return effects.size()

##Returns the index of the [member effect], by name or with the effect's [member resource].
static func find(effect_name_or_ressource):
	if effect_name_or_ressource is Effect:
		if effects.find(effect_name_or_ressource) != -1: 
			return effects.find(effect_name_or_ressource)
		else: push_warning("No valid effect of object", effect_name_or_ressource)
	else:
		for i in effects:
			if i.name == effect_name_or_ressource:
				return i
	push_warning("No valid effect of name", effect_name_or_ressource)

##Activates the [param Effect.EVENT()] function of all valid  [member effects] .
##[br][param event] is [member Effect], followed by 
##the name of the function (ex. [member EFFECT.START_TURN])
##[br]Use [code]await call_event(entity, event)[/code] if this function should 
## halt the rest of the code, ensuring a cohesive order.
static func call_event(entity, event: int):
	for i in range(len(effects)):
		
		if entity.effects[i] > 0:
			match event: #all of the possible Effect.EVENT types.
				START_TURN:
					effects[i].start_turn(entity)
				END_TURN:
					effects[i].end_turn(entity)
				ON_DAMAGE:
					effects[i].on_damage(entity)
				ON_HIT:
					effects[i].on_hit(entity)
				
			await Game.get_tree().create_timer(0.3).timeout
		

static func afflict(entity, effects_list, call_on_hit = true):
	for i in range(len(effects)):
		entity.effects[i] += effects_list[i]
		if call_on_hit: if entity.effects[i] > 0: effects[i].on_hit(entity)
		await Game.get_tree().create_timer(0.3).timeout

##Activates the [code]start_turn()[/code] function of this  [member effect] .
func start_turn(_entity):
	pass
	
##Activates the [code]end_turn()[/code] function of this  [member effect] .
func end_turn(_entity):
	pass

##Activates the [code]on_hit()[/code] function of this  [member effect] .
##By default, adds [param _value] to the entity
func on_hit(_entity):
	pass

func on_damage(_entity):
	pass
	
