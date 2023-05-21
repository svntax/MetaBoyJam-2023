extends Node
 
export (Resource) var loot_table = null

func _ready():
	if loot_table != null:
		assert(loot_table.items.size() == loot_table.weights.size())

func get_loot_table():
	return loot_table

# Returns a chosen item ID (based on Globals.Item)
func get_item_drop():
	if loot_table == null:
		push_warning("Warning: Attempted to drop an item from a null loot table.")
		return null
	
	return loot_table.drop_item()

# Creates a new instance of a random item and adds it to the scene tree.
# Returns the actual item instance dropped, or null if nothing was dropped.
func drop_item():
	if loot_table == null:
		return null
	
	var item_drop = get_item_drop()
	var item_scene = Globals.ITEM_SCENES.get(item_drop, null)
	if item_scene != null:
		# Instance the item
		var item = item_scene.instance()
		
		# Add the item to the scene tree
		var target_parent = get_parent()
		var maps = get_tree().get_nodes_in_group("Maps")
		if maps.size() > 0:
			var map = maps[0]
			target_parent = map.items_root
		target_parent.add_child(item)
		
		return item
	
	return null
