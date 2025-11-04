extends Resource

class_name Effect

@export var effect_name: String
@export_multiline var description: String

static var effects: Array[Effect]

##Defines the  [param array]  of valid effects, used by the  [member Effects]  class and all  [member effects] insatnces. 
##This should be called once by  [member GameManager]. 
##[br]Use  [code]Effect.get_effects()[/code]  to read this array.
static func define_effects(array):
	effects = array
	
##Returns the array of all valid  [member effects], in order.
static func get_effects():
	return effects

##Activates the [code]start_turn()[/code] function of all valid  [member effects] .
static func call_start_turn(entity):
	for effect in effects:
		if entity.effects[effects[effect]] != 0:
			effect.start_turn(entity)

##Activates the [code]take_damage()[/code] function of all valid  [member effects] .
static func call_take_damage(entity):
	for effect in effects:
		if entity.effects[effects[effect]] != 0:
			effect.take_damage(entity)

##Activates the [code]give_damage()[/code] function of all valid  [member effects] .
static func call_give_damage(entity):
	for effect in effects:
		if entity.effects[effects[effect]] != 0:
			effect.give_damage(entity)


##Activates the [code]start_turn()[/code] function of this  [member effect] .
func start_turn(_entity):
	pass

##Activates the [code]take_damage()[/code] function of this  [member effect] .
func take_damage(_entity):
	pass

##Activates the [code]give_damage()[/code] function of this  [member effect] .
func give_damage(_entity):
	pass
