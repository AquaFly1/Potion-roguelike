extends Control

@onready var health: ColorRect = $Health
@onready var burn: ColorRect = $Health/Burn
@onready var poison: ColorRect = $Health/Burn/Poison
@onready var rejuv: ColorRect = $Health/Rejuv
@onready var shield: ColorRect = $Shield

@export var is_player = false

@onready var anim_text: Label = $Anim_text

var entity: Entity

var max_size: float

var old_effects

func _ready() -> void:
	max_size = health.size.x
	if is_player:
		entity = Player
		entity.health_bar = self
	else:
		entity = get_parent().get_parent()
		entity.health_bar = self
		await entity.ready
	
	old_effects = entity.effects.duplicate()
	old_effects.fill(0)
	
	
	update_bar()

func update_bar(_end_turn: bool = false) -> void:
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).set_parallel()
	tween.tween_interval(0) #make sure there is at least something or it cries
	
	for i in [
		[health,"size",entity.health],
		
		[burn,"size", entity.effects[1], _end_turn],
		
		[poison,"size", min(entity.effects[2],1), _end_turn],
		
		[rejuv, "size", min(entity.effects[3],entity.max_health-entity.health), _end_turn],
		
		[shield ,"size" , entity.effects[4]]
			]:
		if i[0].get(i[1]).x != i[2]/entity.max_health * max_size: #if theres a difference
			
			if len(i) == 4 and i[3] == true: #if parallel
				tween.tween_property(
					i[0], 
					i[1], 
					Vector2( i[2]/entity.max_health * max_size , 
							i[0].get(i[1]).y ) ,
					0.5)
			else:
				tween.tween_property(
					i[0], 
					i[1] , 
					Vector2( i[2]/entity.max_health * max_size , 
							i[0].get(i[1]).y ) , 
					0.5)
				anim_text.text = "Applying %s :  %d" %[ i[0].name , int(i[2]) ]
			
			update_visuals()
			
	await tween.finished
	
func update_visuals():
	for i in Effect.effects:
		if entity.effects[Effect.index(i)] - old_effects[Effect.index(i)] != 0:
			entity.update_effect_vfx(i)
			
	old_effects = entity.effects.duplicate()
