extends Resource

class_name Effect

@export var name: String
@export_multiline var description: String

static var effects: Array[Effect]

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
		else: push_warning("No valid effect of name", effect_name_or_ressource)
	else:
		for i in effects:
			print("comparing ",effect_name_or_ressource," with ",i)
			if i.name == effect_name_or_ressource:
				return i
	push_warning("No valid effect of name", effect_name_or_ressource)


##Activates the [code]start_turn()[/code] function of all valid  [member effects] .
static func call_start_turn(entity):
	for i in range(len(effects)):
		if entity.effects[i] != 0:
			effects[i].start_turn(entity)

##Activates the [code]afflict_effect()[/code] function of all valid  [member effects] .
static func call_afflict_effect(entity):
	for i in range(len(effects)):
		if entity.effects[i] != 0:
			effects[i].afflict_effect(entity)

##Activates the [code]give_damage()[/code] function of all valid  [member effects] .
static func call_give_damage(entity):
	for i in range(len(effects)):
		if entity.effects[i] != 0:
			effects[i].give_damage(entity)


##Activates the [code]start_turn()[/code] function of this  [member effect] .
func start_turn(_entity):
	pass

##Activates the [code]afflict_effect()[/code] function of this  [member effect] .
func afflict_effect(_entity):
	pass

##Activates the [code]give_damage()[/code] function of this  [member effect] .
func give_damage(_entity):
	pass
