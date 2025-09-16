extends Control

@onready var const_1_glow: Line2D = $contelation_1/Line2D

@export var constalations = []

var current_const = null

func _on_contelation_1_mouse_entered() -> void:
	const_1_glow.visible = true
	current_const = 1


func _on_contelation_1_mouse_exited() -> void:
	const_1_glow.visible = false
