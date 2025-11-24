extends AnimationTree

func _ready() -> void:
	Game.interaction_ended.connect(rest)
	rest()
	
func rest() -> void:
	set("parameters/rest_or_playing/transition_request", "rest")

func play() -> void:
	set("parameters/rest_or_playing/transition_request", "playing")
	set("parameters/pickup_shot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

func update_hand_size(size: int):
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self,
						"parameters/hold_amount/seek_request",
						2 * float(size)/5,
						0.2
				).from(get("parameters/hold/current_position"))
	#set("parameters/hold_amount/seek_request", 2 * float(size)/5)
	
