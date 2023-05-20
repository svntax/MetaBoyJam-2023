extends Button

onready var parent_obstacle = get_parent()

export (bool) var slashing = false
export (bool) var explosive = false
export (bool) var smash = false
export (bool) var hacking = false
export (bool) var unlock = false
export (bool) var fire = false

export (NodePath) var interact_menu_path = NodePath()
var interact_menu

export (NodePath) var object_name_label_path = NodePath()
var object_name_label

func _ready():
	parent_obstacle.add_to_group("Interactable")
	self.connect("pressed", self, "_on_pressed")
	self.connect("mouse_entered", self, "_on_mouse_entered")
	self.connect("mouse_exited", self, "_on_mouse_exited")
	
	interact_menu = get_node(interact_menu_path)
	interact_menu.hide()
	
	object_name_label = get_node(object_name_label_path)
	object_name_label.hide()
	object_name_label.text = parent_obstacle.get_object_name()

func _on_pressed():
	# Place the menu at the mouse's position
	var ui_pos = get_global_mouse_position() - parent_obstacle.global_position
	ui_pos.x += -(interact_menu.rect_size.x / 2)
	ui_pos.y += -12
	interact_menu.rect_position = ui_pos
	
	interact_menu.show()
	
	# Update the menu with data on the object clicked
	var object_name = parent_obstacle.get_object_name()
	interact_menu.set_object_name(object_name)
	
	var players = get_tree().get_nodes_in_group("Players")
	var current_player = players[0]
	# Find the character that's currently being controlled
	for player in players:
		if player.has_method("is_being_controlled") and player.is_being_controlled():
			current_player = player
			break
	
	var main_weapon_traits = current_player.get_weapon_traits()
	var item_traits = current_player.get_item_traits_in_inventory()
	# TODO: combine with traits of subweapons being held
	var combined_weapon_traits = main_weapon_traits + item_traits
	
	interact_menu.set_object_traits({
		"Slashing": slashing and (Globals.Trait.SLASHING in combined_weapon_traits),
		"Explosive": explosive and (Globals.Trait.EXPLOSIVE in combined_weapon_traits),
		"Smash": smash and (Globals.Trait.SMASH in combined_weapon_traits),
		"Hacking": hacking and (Globals.Trait.HACKING in combined_weapon_traits),
		"Unlock": unlock and (Globals.Trait.UNLOCK in combined_weapon_traits),
		"Fire": fire and (Globals.Trait.FIRE in combined_weapon_traits)
	})
	interact_menu.set_object_reference(parent_obstacle)

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
	interact_menu.hide()
