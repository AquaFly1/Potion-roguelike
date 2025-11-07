extends Label

var interact_text: Array[String] = [""]
var text_tween: Tween
var erase_tween: Tween
@onready var interact_ray_active: int = 0
@export var letters_per_sec: float
var anim_time: float = 20
var is_exit: bool




func add_text(input_text) -> void:
	interact_text.append(input_text)
		
	#tally how many objects say theyre being viewed, value is basically always 0 or 1 but
	#when the viewd object switches it might fuck up a bool if the exit call happens
	#after teh new object's enter call
	interact_ray_active += 1
	
	#basically as long as the text isnt already there, avoid erasing just to put the
	#same thing again
	visible = true
	if text != interact_text[-1] or erase_tween:
		#new anim
		text_tween = create_tween()#.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
		#kill erasing animations if were switching from nothing
		if erase_tween or text == "": 
			if erase_tween: erase_tween.kill()
			text_tween.tween_property(self,"visible_ratio",0,0)
		#anim erase if switching from one to another
		else: text_tween.tween_property(self,"visible_ratio",0,anim_time)
		
		
		#switch the text
		text_tween.tween_property(self,"text",interact_text[-1],0)
		
		#retype the new text
		anim_time = len(interact_text[-1])/letters_per_sec
		text_tween.tween_property(self,"visible_ratio",1,anim_time)
			
	#if looking at nothing
	

func clear_text(input_text) -> void:
	interact_ray_active -=1
	interact_text.erase(input_text)
	
	if interact_ray_active == 0:
		if text_tween: text_tween.kill()
		erase_tween = create_tween()#.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
		
		erase_tween.tween_property(self,"visible_ratio",0,anim_time)
		erase_tween.tween_property(self,"text","",0)
		erase_tween.tween_property(self,"visible",false,0)
		erase_tween.tween_property(self,"visible_ratio",1,0)
	
	elif interact_ray_active < 0:
		push_warning("negative amount of viewed stuff")
