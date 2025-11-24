extends Control

@export var first_menu: Menu
@onready var menu_travel: Array[Menu] = []
var tween: Tween
var tween_active = false
var buffer := false

func _ready() -> void:
	hide()
	Menu.controller = self
	

func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if not menu_travel.is_empty(): menu_travel[-1].escape()
		else: toggle_menu()

func add_buffer() -> bool:
	if tween and tween.is_running():
		if buffer: return false
		buffer = true
		tween.stop()
		#await tween.finished
		buffer = false
		return true
	return true

func toggle_menu() -> void:
	
	if tween: tween.kill()
	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_interval(0)
	if not visible: 
		for i in get_children():
			i.hide()
		
		
		
		tween.tween_property(get_tree(), "paused" , true, 0 )
		tween.tween_property(self,"modulate",Color.WHITE,0.2)
		
		switch_menu(first_menu) #reset the travel
		
		menu_travel.append(first_menu)
		first_menu.show()
		visible = not visible
		
		mouse_filter = Control.MOUSE_FILTER_IGNORE
		Game.mouse_mode = Input.mouse_mode
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
		modulate = Color(0,0,0,0)
		#tween.tween_property(self,"modulate",Color.BLACK,0.1)
		
		
		
	else:
		
		for i in menu_travel: i.visible = false
		menu_travel.clear()
		Input.set_mouse_mode(Game.mouse_mode)
		get_tree().paused = false
		mouse_filter = Control.MOUSE_FILTER_IGNORE
		
		
		tween.parallel().tween_property(self,"modulate",Color.BLACK,0.1)
		#tween.tween_property(previous, "visible",false, 0)
		tween.parallel().tween_property(self,"modulate",Color(0,0,0,0),0.1)
		
		await tween.finished
		visible = not visible
	
	
func switch_menu(next: Menu) -> void:
	var previous
	if menu_travel: previous = menu_travel[-1]
	next.show()
	next.modulate = Color.TRANSPARENT
	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	self.color = Color.BLACK
	if previous:
		tween.tween_property(previous, "modulate",modulate*Color.BLACK, 0.1)
		tween.tween_property(previous, "visible",false, 0)
		tween.tween_property(next, "modulate",Color.BLACK, 0)
	
	tween.tween_property(next, "modulate",Color.WHITE, 0.1)

func set_menu(from: Control, path: NodePath) -> void:
	if tween: tween.kill()
	
	var menu = from.get_node(path)
	if not menu_travel.is_empty(): switch_menu(menu)
	menu_travel.append(menu)
	
func back() -> void:
	if tween: tween.kill()
	if len(menu_travel) >= 2:
		switch_menu(menu_travel[-2])
		menu_travel.remove_at(-1)
	else:
		toggle_menu()
	
func update_psx(value, option: String):
	PsxLoader.update_setting(option,value)

func update_psx_slider(value, from: Control, option: String, target_label = null, label_string_list: Array = []):
	PsxLoader.update_setting(option,value)
	if target_label: from.get_node(target_label).text = label_string_list[value]
	
func update_psx_slider_percent(value, from: Control, option: String, target_label = null):
	PsxLoader.update_setting(option,value)
	if target_label: from.get_node(target_label).text = str(int(value*100)) + "%"

func slider_unselect(_value, slider: HSlider):
	slider.release_focus()
	
func make_see_through(col: Color):
	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self,"color",col,0.3)


		
