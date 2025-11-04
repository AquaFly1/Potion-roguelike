extends Resource

class_name Ring

@export var ring_name: String
@export_multiline var description: String
@export var icon: Texture2D

##The name of the ring events callable with call_event(entity, RING.EVENT).
##[br]Functionally just redefined ints.
enum {
	START_TURN,
	END_TURN,
	ON_HIT,
	ON_DAMAGE,
}

var bonus_damage: int = 0

##Activates the [param Ring.EVENT()] function of all valid  [member rings] .
##[br][param event] must be a Ring.EVENT (ex. [member Ring.START_TURN])
##[br]Use [code]await call_event(entity, event)[/code] if this function should 
## halt the rest of the code, ensuring a cohesive order.
static func call_event(entity, event: int):
	for ring in entity.rings:
		
		match event: #all of the possible Ring.EVENT types.
			START_TURN:
				ring.start_turn(entity)
			END_TURN:
				ring.end_turn(entity)
			ON_DAMAGE:
				ring.on_damage(entity)
			ON_HIT:
				ring.on_hit(entity)
				
		await Game.get_tree().create_timer(0.1).timeout


func activate(_ings: Array[Ingredient]):
	pass

func potion_thrown(_ings: Array[Ingredient]) -> Array[Tag]:
	return []
	
func start_turn(_entity):
	pass

func end_turn(_entity):
	pass
	
func on_hit(_entity):
	pass

func on_damage(_entity):
	pass
