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
	interact_menu.set_object_traits({
		"Slashing": slashing,
		"Explosive": explosive,
		"Smash": smash,
		"Hacking": hacking,
		"Unlock": unlock,
		"Fire": fire
	})
	interact_menu.set_object_reference(parent_obstacle)

func _on_mouse_entered():
	object_name_label.show()

func _on_mouse_exited():
	object_name_label.hide()

# TODO: listen to signals that may interrupt the menu
func hide_menu():
	interact_menu.hide()
