extends SubViewportContainer

@export var default_resolution := 1080.0
var multiplier := 1.0

func _ready() -> void:
	update_resolution(default_resolution)


func update_resolution(res) -> void:
	multiplier = 1080/res
	size = Vector2(1920/multiplier,1080/multiplier)
	#scale = Vector2.ONE * multiplier
	
#func _input(event):
	## Only forward mouse events to the SubViewport
	#if event is InputEventMouse or event is InputEventMouseButton:
		#var ev = event.duplicate()  # duplicate so it doesn't consume original
		#$SubViewport.push_input(ev)
