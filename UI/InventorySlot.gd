extends Control

onready var icon = $IconContainer/Icon # TODO: not needed if reparenting the item itself?
onready var count_label = $CountLabel
onready var item_root = $"%ItemRoot"

onready var item_reference = null

func _ready():
	set_count(-1)

func set_count(count: int) -> void:
	if count >= 1:
		count_label.text = str(count)
		count_label.show()
	else:
		count_label.text = ""
		count_label.hide()

func set_icon(sprite: Sprite) -> void:
	if sprite == null:
		#icon.hide()
		count_label.hide()
		return
	
	#icon.show()
	var texture = sprite.texture
	icon.texture = sprite.texture

func clear_slot() -> void:
	#icon.hide()
	count_label.hide()
	if item_reference != null:
		# We drop the item here because the position it drops at will depend on
		# who or what drops it.
		var map = get_tree().get_nodes_in_group("Maps")[0]
		var items_root = map.items_root
		item_reference.get_parent().remove_child(item_reference)
		# Drop at the player's position
		items_root.add_child(item_reference)
		item_reference.global_position = map.get_player().global_position
	
	item_reference = null

func set_item_reference(object) -> void:
	item_reference = object

func is_slot_in_use() -> bool:
	return item_reference != null

# Used in combination with the main weapon data to calculate what the player can
# interact with.
func get_item_data() -> Dictionary:
	if item_reference == null:
		return {}
	return item_reference.get_item_data()
