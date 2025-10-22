extends Control

@export var rings_to_buy: Array[Ring]
@onready var rings_container: HBoxContainer = $HBoxContainer

func _ready() -> void:
	for child in rings_container.get_children():
		if rings_to_buy != []:
			var child_ring = rings_to_buy.pop_at(randi_range(0, len(rings_to_buy)-1))
			child.ring = child_ring
		else:
			child.queue_free()
	
