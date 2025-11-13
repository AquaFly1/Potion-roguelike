extends Control

@export var first_menu: Menu
@onready var menu_travel: Array[Menu] = []

func _ready() -> void:
	hide()
	Menu.controller = self


func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if not menu_travel.is_empty(): menu_travel[-1].escape()
		else: toggle_menu()


func toggle_menu() -> void:
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	if not visible: 
		set_menu(self, first_menu.get_path()) #reset the travel
		first_menu.show()
		visible = not visible
		
		mouse_filter = Control.MOUSE_FILTER_IGNORE
		Game.mouse_mode = Input.mouse_mode
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
		modulate = Color(0,0,0,0)
		tween.tween_property(self,"modulate",Color.BLACK,0.1)
		
		tween.tween_property(Game.main_node, "process_mode" , Node.PROCESS_MODE_DISABLED, 0 )
		
		
		tween.tween_property(self,"modulate",Color.WHITE,0.2)
	else:
		menu_travel.clear()
		Input.set_mouse_mode(Game.mouse_mode)
		Game.main_node.process_mode = Node.PROCESS_MODE_INHERIT
		mouse_filter = Control.MOUSE_FILTER_IGNORE
		
		tween.tween_property(self,"modulate",Color.BLACK,0.1)
		tween.tween_property(self,"modulate",Color(0,0,0,0),0.1)
		
		await tween.finished
		visible = not visible
	
func switch_menu(next: Menu) -> void:
	var previous = menu_travel[-1]
	next.show()
	next.modulate = Color.TRANSPARENT
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(previous, "modulate",Color.TRANSPARENT, 0.1)
	tween.tween_property(previous, "visible",false, 0)
	tween.tween_property(next, "modulate",Color.WHITE, 0.1)

func set_menu(from: Control, path: NodePath) -> void:
	var menu = from.get_node(path)
	if not menu_travel.is_empty(): switch_menu(menu)
	menu_travel.append(menu)
	
func back() -> void:
	if len(menu_travel) >= 2:
		switch_menu(menu_travel[-2])
		menu_travel.remove_at(-1)
	else:
		menu_travel[-1].visible = false
		toggle_menu()
	
	
