extends Area2D

signal picked_up(item)
signal dropped(item)
signal consumed(item) # TODO

onready var sprite = $Sprite
onready var animation_player = $AnimationPlayer
onready var interact_pickup_button = $InteractPickup

func _ready():
	animation_player.play("hover")
	
	# Not sure if this is the best way to connect items to the inventory.
	var inventory_menus = get_tree().get_nodes_in_group("InventoryMenu")
	if inventory_menus.empty():
		push_warning("WARNING: Item " + str(self.name) + " could not find the inventory menu.")
	var inventory_menu = inventory_menus[0]
	if inventory_menu == null:
		push_warning("WARNING: Item " + str(self.name) + " could not find the inventory menu.")
	else:
		self.connect("picked_up", inventory_menu, "on_item_picked_up")
		self.connect("dropped", inventory_menu, "on_item_dropped")
		# TODO consumed

func get_icon() -> Sprite:
	return sprite

func get_item_data() -> Dictionary:
	return interact_pickup_button.get_item_data()

func get_object_name() -> String:
	return "Knife"

func on_picked_up() -> void:
	emit_signal("picked_up", self)

func on_dropped() -> void:
	interact_pickup_button.in_inventory = false
	animation_player.play("hover")
	emit_signal("dropped", self)

func on_consumed() -> void:
	pass # TODO: stackable items
