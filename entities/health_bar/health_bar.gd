extends Control

@onready var health: ColorRect = $Health
@onready var burn: ColorRect = $Health/Burn
@onready var poison: ColorRect = $Health/Burn/Poison
@onready var rejuv: ColorRect = $Health/Rejuv
@onready var shield: ColorRect = $Health/Shield

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

func update_bar(effect: Effect = null) -> void:
	
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.set_parallel()
	tween.tween_interval(0) #make sure there is at least something or it cries
	
	for i in [
		[health,"size",entity.health],
		
		[burn,"size", entity.effects[1]],
		
		[poison,"size", min(entity.effects[2],1)],
		
		[rejuv, "size", min(entity.effects[3],entity.max_health-entity.health)],
		
		[shield ,"size" , entity.effects[4]]
			]:
		
		var new_size = Vector2( max(i[2]/entity.max_health * max_size,0) , i[0].get(i[1]).y).snappedf(1)
			
		if i[0].get(i[1]) != new_size:
			
			tween.tween_property(
				i[0], 
				i[1] , 
				new_size , 
				0.5)
			anim_text.text = "Applying %s :  %d" %[ i[0].name , int(i[2]) ]
		
		if effect: 	entity.update_effect_vfx(effect)
		else: update_visuals()
			
	await tween.finished
	
func update_visuals():
	for i in Effect.effects:
		if entity.effects[Effect.index(i)] - old_effects[Effect.index(i)] != 0:
			entity.update_effect_vfx(i)
			
	old_effects = entity.effects.duplicate()
