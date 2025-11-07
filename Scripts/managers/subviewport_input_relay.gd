extends Control

func _input(event: InputEvent):
	# Only forward mouse events to the SubViewport
	if event is InputEventMouse or event is InputEventMouseButton:
		var ev = event.duplicate()  # duplicate so it doesn't consume original
		$"../2D/SubViewport".push_input(ev,true)
