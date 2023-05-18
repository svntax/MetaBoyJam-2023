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
	if object.has_method("on_slashed"):
		pass

func _on_DoneButton_pressed():
	hide()
