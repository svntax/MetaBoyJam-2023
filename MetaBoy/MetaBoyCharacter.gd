extends KinematicBody2D

onready var speed = 160
onready var velocity = Vector2()

onready var metaboy = $MetaBoy

# If we want to be able to control different characters
onready var in_control = true

func _ready():
	metaboy.part_background.hide()

func is_being_controlled() -> bool:
	return in_control

func set_attributes(attributes: Dictionary) -> void:
	metaboy.set_metaboy_attributes(attributes)

func _physics_process(_delta: float) -> void:
	# Movement
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if input_dir.length_squared() > 1.0:
		input_dir = input_dir.normalized()
	velocity = input_dir * speed
	move_and_slide(velocity)
	
	# Animations
	if velocity.x != 0 or velocity.y != 0:
		metaboy.animation_player.play("run", -1, 2.0)
	else:
		metaboy.animation_player.play("idle")
	if velocity.x < 0:
		metaboy.body_root.scale.x = -1
	elif velocity.x > 0:
		metaboy.body_root.scale.x = 1

func get_weapon_traits() -> Dictionary:
	var weapon = metaboy.metaboy_data.weapon
	if weapon.empty():
		push_warning("Warning: Could not get the weapon name of the player's MetaBoy.")
		weapon = "Boxing-Gloves" # Default to Boxing-Gloves because of the Smash trait
	
	var weapon_data = Globals.weapon_data.get(weapon)
	var weapon_traits = weapon_data.get("Traits", [])
	return weapon_traits
