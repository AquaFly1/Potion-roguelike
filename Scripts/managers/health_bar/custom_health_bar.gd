extends HBoxContainer

@export var max_health: int = 10
@export var health: int = 0
@export var burn: int = 0
@export var poison: int = 0
@export var rejuv: int = 0
@export var freeze: int = 0
@export var shield: int = 0

@onready var freeze_effect: Control = $"../freeze"
@onready var freeze_top: TextureRect = $"../freeze/freeze_top"
@onready var freeze_bottom: TextureRect = $"../freeze/freeze_bottom"

var tab_scene = preload("res://Scenes/managers/health_bar/tab.tscn")
var tab_size: Vector2
var tabs: Array = []

func _ready() -> void:
	# Create the tabs only once
	for i in range(max_health):
		var new_tab = tab_scene.instantiate()
		add_child(new_tab)
		tabs.append(new_tab)
	
	# Set the tab size based on the total container size
	await get_tree().process_frame  # wait one frame for size to update
	tab_size = Vector2(size.x / max_health, size.y)
	for t in tabs:
		t.custom_minimum_size = tab_size
	freeze_top.size.x = size.x
	freeze_bottom.size.x = size.x

func _process(_delta: float) -> void:
	# Clamp values
	burn = max(burn, 0)
	poison = max(poison, 0)
	rejuv = max(rejuv, 0)
	freeze = max(freeze, 0)
	shield = max(shield, 0)
	health = clamp(health, 0, max_health)
	
	if freeze >0:
		freeze_effect.visible = true
	else:
		freeze_effect.visible = false
	
	# Reset all colors first
	for t in tabs:
		t.modulate = Color(0.2, 0.2, 0.2, 1.0) # grey or base color
	
	# Color for health
	for i in range(health):
		tabs[i].modulate = Color(1, 0, 0, 1) # red
	
	# Burn overlay (orange, applied after health)
	for i in range(min(burn, health)):
		tabs[health - 1 - i].modulate = Color(1.0, 0.467, 0.0, 1.0)
	
	# Poison overlay (green)
	for i in range(min(poison, health)):
		tabs[health - 1 - burn - i].modulate = Color(0.0, 1.0, 0.0, 1.0)
	
	if rejuv > 0:
		tabs[health].modulate = Color(1,1,0)
	
	if rejuv > 0:
		for i in range(shield):
			tabs[health + i + 1].modulate = Color(0,0,1)
	else:
		for i in range(shield):
			tabs[health + i].modulate = Color(0,0,1)
