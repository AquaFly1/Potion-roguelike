extends Label

var text_tween: Tween
var erase_tween: Tween
@export var letters_per_sec: float
var anim_time: float = 20
var is_exit: bool

func set_popup_text(input_text) -> void:
	if text != input_text and not (erase_tween and erase_tween.is_running()):
		if input_text == "":
			
			if text_tween: text_tween.kill()
			erase_tween = create_tween()#.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
				
			erase_tween.tween_property(self,"visible_ratio",0,anim_time)
			erase_tween.tween_property(self,"text","",0)
			erase_tween.tween_property(self,"visible",false,0)
			erase_tween.tween_property(self,"visible_ratio",1,0)
			
			
		else:
			#new anim
			text_tween = create_tween()#.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
			#kill erasing animations if were switching from nothing
			if erase_tween or text == "": 
				if erase_tween: erase_tween.kill()
				text_tween.tween_property(self,"visible_ratio",0,0)
			#anim erase if switching from one to another
			else: text_tween.tween_property(self,"visible_ratio",0,anim_time)
			
				#switch the text
			text_tween.tween_property(self,"text",input_text,0)
			visible = true
			#retype the new text
			anim_time = len(input_text)/letters_per_sec
			text_tween.tween_property(self,"visible_ratio",1,anim_time)
			
