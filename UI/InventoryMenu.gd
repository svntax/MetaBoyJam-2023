extends VBoxContainer

onready var inventory_slots = get_children()

# Note sure if I need this
#func remove_item_at(slot_index: int) -> void:
#	if 0 <= slot_index and slot_index < get_child_count():
#		var slot = get_child(slot_index)
#		slot.clear_slot()

func add_item(item: Node2D) -> bool:
	var empty_slot = get_first_empty_slot()
	if empty_slot == null:
		# Inventory full
		return false
	empty_slot.set_item_reference(item)
	#empty_slot.set_icon(item.get_icon())
	# Move the item physically over to the inventory
	item.get_parent().remove_child(item)
	empty_slot.item_root.add_child(item)
	item.position = Vector2()
	return true

func get_first_empty_slot():
	for slot in inventory_slots:
		if not slot.is_slot_in_use():
			return slot
	
	return null

# Attempt to add an item that the player is trying to pick up.
func on_item_picked_up(item) -> void:
	var success = add_item(item)
	if not success:
		# TODO: tell the player their inventory is full
		print("Inventory full")

func on_item_dropped(item) -> void:
	for slot in inventory_slots:
		if slot.item_reference == item:
			slot.clear_slot()
			break
