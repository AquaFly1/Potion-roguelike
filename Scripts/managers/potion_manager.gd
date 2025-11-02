extends Node

func activate_rings(ings: Array[Ingredient], rings: Array[Ring]) -> Array[Tag]:
	var new_tags: Array[Tag] = []
	for ring in rings:
		new_tags.append_array(ring.potion_thrown(ings))
	
	return new_tags

func transfer_ingredients(ings: Array[Ingredient], rings: Array[Ring]) -> Array[Tag]:
	var tags = []
	for ingredient in ings: 
		tags.append_array(ingredient.tags)
	tags.append_array(activate_rings(ings, rings))
	var unique_tags: Array[Tag]
	for i in tags:
		if i not in unique_tags:
			unique_tags.append(i)
	return unique_tags

func calculate_combos(ings: Array[Ingredient], rings: Array[Ring]):
	var tags = transfer_ingredients(ings, rings)
	var active_combos = []

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

func throw_potion(entity: Entity, ingredients: Array[Ingredient], rings: Array[Ring]):
	var effects = [0,0,0,0,0,0,0,0,0,0,0]
	for combo in calculate_combos(ingredients, rings):
		effects += combo.effects

	entity.effects += effects
	EffectMan.take_damage(entity)
