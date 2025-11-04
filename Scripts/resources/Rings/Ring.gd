extends Resource

class_name Ring

@export var ring_name: String
@export_multiline var description: String
@export var icon: Texture2D



var bonus_damage: int = 0

static func call_start_turn(entity: Entity):
	for ring in entity.rings:
		ring.start_turn(entity)

func activate(_ings: Array[Ingredient]):
	pass

func potion_thrown(_ings: Array[Ingredient]) -> Array[Tag]:
	return []
	
func start_turn(_entity):
	pass
