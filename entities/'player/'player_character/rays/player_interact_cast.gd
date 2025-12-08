extends RayCast3D

var chest_look: Node3D = null
var candle_look: Node3D = null
var break_chance: int = 10
@export var popup_label: Label
@export var name_and_text: Dictionary[String,String]
var prev_object: Node3D


func _physics_process(_delta: float) -> void:
	
	if get_collider():
		var valid := false
		var object = get_collider().get_parent()
		for i in name_and_text.keys():
			if i in object.name:
				if object != prev_object: popup_label.set_popup_text("")
				else:	popup_label.set_popup_text(name_and_text[i])
				valid = true
				
				prev_object = object
				break
		if not valid:
			popup_label.set_popup_text("")
		
		
	else:
		popup_label.set_popup_text("")
	

	

func _unhandled_input(_event: InputEvent) -> void:
	
	if _event is InputEventMouseButton \
		and _event.button_index == MOUSE_BUTTON_LEFT \
		and _event.is_pressed():
			if get_collider(): 
				get_collider().input_event.emit(Player.node.camera, _event)
			
	
	if Input.is_action_just_pressed("interact"):
		var type := ""
		var object : Node3D
		if get_collider(): object = get_collider().get_parent()
		if object:
			for i in name_and_text.keys(): if i in object.name:
				type = i
				
			match type:
				"Candle":
					if randi_range(1,break_chance) != break_chance:
						object.light_candle()
				"Chest":
					object.open_chest()

	
