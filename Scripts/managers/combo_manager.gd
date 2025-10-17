extends Node

@export var ings: Array[Ingredient]

var tags: Array[Tag]

func find_combos(ingredients: Array[Ingredient]):
	tags = []
	var active_combos: Array[Combo]
	for ingredient in ingredients: 
		for tag in ingredient.tags:
			tags.append(tag)
	var unique_tags: Array[Tag]
	for i in tags:
		if i not in unique_tags:
			unique_tags.append(i)
	tags = unique_tags
	for combo in Game.combos:
		var enabled = true
		for tag in combo.tags_needed:
			if tag not in tags:
				enabled = false
		if enabled:
			active_combos.append(combo)
			for deleted in combo.combos_removed:
				if deleted in active_combos:
					active_combos.erase(deleted)
	return active_combos

func _ready() -> void:
	pass
