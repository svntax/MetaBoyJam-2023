extends Button

enum Trait {SLASHING, EXPLOSIVE, SMASH, PIERCING, HACKING, UNLOCK, FIRE}
enum Attack {MELEE, RANGED}

onready var parent_obstacle = get_parent()

export (bool) var slashing = false
export (bool) var explosive = false
export (bool) var smash = false
export (bool) var piercing = false
export (bool) var hacking = false
export (bool) var unlock = false
export (bool) var fire = false

export (Attack) var attack_type = Attack.MELEE
var item_data = {}

export (NodePath) var item_pickup_menu_path = NodePath()
var item_pickup_menu

export (NodePath) var object_name_label_path = NodePath()
var object_name_label

onready var in_inventory = false

func _ready():
	parent_obstacle.add_to_group("Interactable")
	self.connect("pressed", self, "_on_pressed")
	self.connect("mouse_entered", self, "_on_mouse_entered")
	self.connect("mouse_exited", self, "_on_mouse_exited")
	
	item_pickup_menu = get_node(item_pickup_menu_path)
	item_pickup_menu.hide()
	
	object_name_label = get_node(object_name_label_path)
	object_name_label.hide()
	object_name_label.text = parent_obstacle.get_object_name()
	
	var traits = []
	if slashing:
		traits.append(Globals.Trait.SLASHING)
	if explosive:
		traits.append(Globals.Trait.EXPLOSIVE)
	if smash:
		traits.append(Globals.Trait.SMASH)
	if piercing:
		traits.append(Globals.Trait.PIERCING)
	if hacking:
		traits.append(Globals.Trait.HACKING)
	if unlock:
		traits.append(Globals.Trait.UNLOCK)
	if fire:
		traits.append(Globals.Trait.FIRE)
	item_data = {"Attack": attack_type, "Traits": traits}

func get_item_data() -> Dictionary:
	return item_data

func _on_pressed():
	# Place the menu at the mouse's position
	var ui_pos = get_global_mouse_position() - parent_obstacle.global_position
	ui_pos.x += -(item_pickup_menu.rect_size.x / 2)
	ui_pos.y += -12
	if in_inventory:
		ui_pos.x -= 16 # Because the inventory is to the side of the window
	item_pickup_menu.rect_position = ui_pos
	
	item_pickup_menu.display(in_inventory)
	
	# Update the menu with data on the object clicked
	var object_name = parent_obstacle.get_object_name()
	item_pickup_menu.set_object_name(object_name)
	
	var players = get_tree().get_nodes_in_group("Players")
	var current_player = players[0]
	# Find the character that's currently being controlled
	for player in players:
		if player.has_method("is_being_controlled") and player.is_being_controlled():
			current_player = player
			break
	
	var main_weapon_traits = current_player.get_weapon_traits()
	item_pickup_menu.set_object_reference(parent_obstacle)

func _on_mouse_entered():
	if get_tree().paused:
		# Hacky fix to prevent name from showing up while game is paused
		object_name_label.hide()
	else:
		object_name_label.show()

func _on_mouse_exited():
	object_name_label.hide()

# TODO: listen to signals that may interrupt the menu
func hide_menu():
	item_pickup_menu.hide()
