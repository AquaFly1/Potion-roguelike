extends RayCast3D

var candle_look: Node3D = null
var break_chance: int = 10
@export var popup_label: Label

func _physics_process(_delta: float) -> void:
	
	if get_collider() and get_collider().get_parent().name == "Candle":
		if candle_look != get_collider().get_parent():
			#popup_label.interact_text = "[E]: Light candle"
			popup_label.add_text("[E]: Light candle")
		candle_look = get_collider().get_parent()
		
	else:
		if candle_look:
			popup_label.clear_text()
		candle_look = null
		
		
func _unhandled_key_input(_event: InputEvent) -> void:
	
	if Input.is_action_just_pressed("interact"):
		if candle_look and randi_range(1,break_chance) != break_chance:
			candle_look.light_candle()
	
