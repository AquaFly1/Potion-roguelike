extends RayCast3D

var candle_look = Node3D

@onready var interact_text: Label = $"../../../Interact_text"

func _physics_process(_delta: float) -> void:
	
	if get_collider() and get_collider().get_parent().name == "Candle":
		interact_text.visible = true
		candle_look = get_collider().get_parent()
	else:
		candle_look = null
		interact_text.visible = false
		
func _unhandled_key_input(_event: InputEvent) -> void:
	
	if Input.is_action_just_pressed("interact"):
		if candle_look:
			candle_look.light_candle()
	
