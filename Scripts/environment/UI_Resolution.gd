extends TextureRect

@export var default_resolution := 1080.0
var multiplier := 1.0

func _ready() -> void:
	update_resolution(default_resolution)


func update_resolution(res) -> void:
	multiplier = 1080/res
	size = Vector2(1920/multiplier,1080/multiplier)
	scale = Vector2.ONE * multiplier
	#$SubViewport.size = size ##
	#scale = Vector2.ONE * multiplier
	
