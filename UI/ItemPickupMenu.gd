extends MarginContainer

onready var object_name_label = $"%ObjectNameLabel"

onready var pick_up_button = $"%PickUpButton"
onready var drop_button = $"%DropButton"

func _ready():
	pick_up_button.hide()
	drop_button.hide()
	rect_size = Vector2()

func _input(event):
	if visible:
		if event is InputEventMouseButton and event.pressed:
			var local_pos = make_input_local(event)
			if !Rect2(Vector2(0,0),rect_size).has_point(local_pos.position):
				hide()

# Displays either the drop button if in the player's inventory, or the pickup
# button if on the floor.
func display(in_inventory: bool) -> void:
	show()
	
	if in_inventory:
		pick_up_button.hide()
		drop_button.show()
	else:
		pick_up_button.show()
		drop_button.hide()
	
	# Resize to fit contents
	rect_size = Vector2()

func set_object_name(value: String) -> void:
	object_name_label.text = value

func set_object_reference(object: Node2D) -> void:
	_connect_interaction(pick_up_button, object, "on_picked_up")
	_connect_interaction(drop_button, object, "on_dropped")

# Helper method to connect buttons to corresponding callback methods from the
# target object.
func _connect_interaction(button, target_object, target_function_name) -> void:
	if target_object.has_method(target_function_name):
		if not button.is_connected("pressed", target_object, target_function_name):
			button.connect("pressed", target_object, target_function_name)
	# Also connect it to this node to hide after pressing
	if not button.is_connected("pressed", self, "_on_interaction_pressed"):
		button.connect("pressed", self, "_on_interaction_pressed")

func _on_interaction_pressed():
	hide()

func _on_DoneButton_pressed():
	hide()
