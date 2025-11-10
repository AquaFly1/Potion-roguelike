extends Node

@export var subviewport: SubViewport

func _input(event: InputEvent):
	# Only forward mouse events to the SubViewport
	if event is InputEventMouse or event is InputEventMouseButton:
		var ev = event.duplicate()  # duplicate so it doesn't consume original
		subviewport.push_input(ev,true)
