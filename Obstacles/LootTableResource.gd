extends Resource
class_name LootTableResource

export (Array, String) var items = []
export (Array, int) var weights = []

func drop_item() -> int:
	# Randomize the loot drops
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	if items.size() != weights.size():
		push_error("Error: Loot table does not have matching array lengths.")
	var chosen_item = -1
	var total_weight = 0
	for weight in weights:
		total_weight += weight

	var rand = rng.randf() * total_weight
	var sum = 0
	for i in range(weights.size()):
		sum += weights[i]
		if rand < sum:
			# Spawn item and exit loop
			chosen_item = items[i]
			break
	
	return chosen_item
