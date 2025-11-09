extends Control

@onready var health: ColorRect = $Health
@onready var burn: ColorRect = $Health/Burn
@onready var poison: ColorRect = $Health/Burn/Poison
@onready var rejuv: ColorRect = $Health/Rejuv
@onready var shield: ColorRect = $Shield

@export var is_player = false

@onready var anim_text: Label = $Anim_panel/Anim_text

var entity: Entity

var max_size: float

func _ready() -> void:
	max_size = health.size.x
	if is_player:
		entity = Player
		entity.health_bar = self
	else:
		entity = get_parent().get_parent()
		entity.health_bar = self
		await entity.ready
	
	
	update_bar()

func update_bar(_end_turn: bool = false) -> void:
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	var health_size := (entity.health/entity.max_health) * max_size
	tween.tween_interval(0)
	for i in [
		[health,"size",health_size],
		
		[burn,"size", (entity.effects[1]/entity.max_health) * max_size, _end_turn],
		
		[poison,"size", min(min(entity.effects[2],1),entity.health)/entity.max_health * max_size, _end_turn],
		
		[rejuv, "size", entity.effects[3]/entity.max_health * max_size, _end_turn],
		[shield ,"size" , entity.effects[4]/entity.max_health * max_size]
			]:
		
		if i[0].get(i[1]).x != i[2]: #if theres a difference
			if len(i) == 4 and i[3] == true: #if parallel
				tween.parallel().tween_property(i[0], i[1] , Vector2( i[2] , i[0].get(i[1]).y ) , 0.5)
			else:
				tween.tween_property(i[0], i[1] , Vector2( i[2] , i[0].get(i[1]).y ) , 0.5)
			await tween.finished
			anim_text.text = "Applying %s" % i[0].name
			
			
	await tween.finished
	
	
