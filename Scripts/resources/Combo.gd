extends Resource

class_name Combo

@export var name: String
@export var tags_needed: Array[Tag]
@export var combos_removed: Array[Combo]
@export var effects = {}
var upgrade = {}
var eff_array: Array[float]

func _to_string() -> String:
	return "Ingredient(%s)" % name

## returns the effects of the  [member combo]  as a valid  [member effects array]  
func effect_values() -> Array:
	if eff_array.is_empty(): #convert it to array if it hasnt done that already
		eff_array.resize(Effect.get_length())
		eff_array.fill(0)
		for i in effects.keys():
			eff_array[Effect.find(i)] = effects[i]
	return eff_array

## defines the upgrade dictionary by halving each value of the base effects and rounding them up
func def_upgrade():
	for i in range(effects.size()):
		var value = effects.values()[i]
		value /= 2
		ceil(value)
		upgrade.values()[i] = float(value)

## adds each value of each effect of the upgrade dictionary to the effect dictionary
func upgrade_effetcs():
	for i in range(effects.size()):
		effects.values()[i] += upgrade.values()[i]
