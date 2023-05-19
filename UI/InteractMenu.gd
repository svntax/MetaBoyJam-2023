extends MarginContainer

onready var object_name_label = $"%ObjectNameLabel"

onready var slash_button = $"%SlashButton"
onready var explode_button = $"%ExplodeButton"
onready var smash_button = $"%SmashButton"
onready var hack_button = $"%HackButton"
onready var picklock_button = $"%PicklockButton"
onready var burn_button = $"%BurnButton"

func _ready():
	slash_button.hide()
	explode_button.hide()
	smash_button.hide()
	hack_button.hide()
	picklock_button.hide()
	burn_button.hide()
	rect_size = Vector2()

func _input(event):
	if visible:
		if event is InputEventMouseButton and event.pressed:
			var local_pos = make_input_local(event)
			if !Rect2(Vector2(0,0),rect_size).has_point(local_pos.position):
				hide()

func set_object_name(value: String) -> void:
	object_name_label.text = value

func set_object_traits(traits: Dictionary) -> void:
	slash_button.visible = traits.get("Slashing", false)
	explode_button.visible = traits.get("Explosive", false)
	smash_button.visible = traits.get("Smash", false)
	hack_button.visible = traits.get("Hacking", false)
	picklock_button.visible = traits.get("Unlock", false)
	burn_button.visible = traits.get("Fire", false)
	
	# Resize to fit contents
	rect_size = Vector2()

func set_object_reference(object: Node2D) -> void:
	_connect_interaction(slash_button, object, "on_slashed")
	_connect_interaction(explode_button, object, "on_exploded")
	_connect_interaction(smash_button, object, "on_smashed")
	_connect_interaction(hack_button, object, "on_hacked")
	_connect_interaction(picklock_button, object, 'on_picklocked')
	_connect_interaction(burn_button, object, "on_burned")
	
	# Renames for specific objects
	if object.get_object_name() == "Iron Door":
		burn_button.text = "Melt"

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
