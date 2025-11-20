extends Control

@export var subviewport: SubViewport

func _input(event: InputEvent) -> void:
	subviewport.push_input(event.duplicate(),true)
