extends RayCast3D

var chest_look: Node3D = null
var candle_look: Node3D = null
var break_chance: int = 10
@export var popup_label: Label
var node_ref := {} ##Dictionnary of Interacteables you are looking at. ex: looking at a candle -> node_ref["Candle"] = candleNode 



func _physics_process(_delta: float) -> void:
	check_for("Candle", "[E]: Light candle")
	check_for("Chest", "[E]: Open chest")
	#if get_collider() and "Candle" in get_collider().get_parent().name:
		#if candle_look != get_collider().get_parent():
			##popup_label.interact_text = "[E]: Light candle"
			#popup_label.add_text("[E]: Light candle")
		#candle_look = get_collider().get_parent()
		#
	#else:
		#if candle_look:
			#popup_label.clear_text("[E]: Light candle")
		#candle_look = null
#
	#if get_collider() and "Chest" in get_collider().name:
		#if chest_look != get_collider():
			##popup_label.interact_text = "[E]: Light candle"
			#popup_label.add_text("[E]: Open chest")
		#chest_look = get_collider()
	#else:
		#if chest_look:
			#popup_label.clear_text("[E]: Open chest")
		#chest_look = null

func check_for(object_hint: String, text: String) -> void:
	if get_collider() and object_hint in get_collider().get_parent().name:
		if node_ref.get(object_hint) != get_collider().get_parent():
			popup_label.add_text(text)
		node_ref[object_hint] = get_collider().get_parent()
		
	else:
		if node_ref.get(object_hint):
			popup_label.clear_text(text)
			node_ref.erase(object_hint)

func _unhandled_key_input(_event: InputEvent) -> void:
	
	if Input.is_action_just_pressed("interact"):
		if node_ref.get("Candle"):
			if randi_range(1,break_chance) != break_chance:
				node_ref.get("Candle").light_candle()
			else:
				pass
				#alumette se brise animation
		elif node_ref.get("Chest"): node_ref.get("Chest").open_chest()
	
