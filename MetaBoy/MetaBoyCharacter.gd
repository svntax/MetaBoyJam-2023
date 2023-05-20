extends KinematicBody2D

onready var speed = 160
onready var velocity = Vector2()

onready var metaboy = $MetaBoy
onready var attack_animation_player = $AttackAnimationPlayer
onready var attack_cooldown_timer = $AttackCooldownTimer
onready var melee_damage_area = $MeleeRoot/SlashDamageArea
onready var melee_root = $MeleeRoot

# If we want to be able to control different characters
onready var in_control = true

func _ready():
	metaboy.part_background.hide()

func is_being_controlled() -> bool:
	return in_control

func set_attributes(attributes: Dictionary) -> void:
	metaboy.set_metaboy_attributes(attributes)

func _physics_process(delta: float) -> void:
	# Movement
	handle_movement(delta)
	
	# Animations
	if velocity.x != 0 or velocity.y != 0:
		metaboy.animation_player.play("run", -1, 2.0)
	else:
		metaboy.animation_player.play("idle")
	if velocity.x < 0:
		metaboy.body_root.scale.x = -1
	elif velocity.x > 0:
		metaboy.body_root.scale.x = 1

# Click event in this function so that it doesn't trigger if clicking on a menu.
func _unhandled_input(event):
	if event is InputEventMouse:
		if event.is_action_pressed("attack") and can_attack():
			attack()

func can_move() -> bool:
	return in_control

func handle_movement(_delta: float) -> void:
	if can_move():
		var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		if input_dir.length_squared() > 1.0:
			input_dir = input_dir.normalized()
		velocity = input_dir * speed
		move_and_slide(velocity)
		
		# Aiming
		if can_aim():
			melee_root.rotation = global_position.direction_to(get_global_mouse_position()).angle()
	else:
		velocity.x = 0
		velocity.y = 0

func attack() -> void:
	attack_cooldown_timer.start()
	
	# Get the data for the equipped weapon
	var equipped_weapon_data = get_equipped_weapon_data()
	var weapon_traits = equipped_weapon_data.get("Traits", [])
	var weapon_attack_type = equipped_weapon_data.get("Attack", -1)
	var attack_type = get_weapon_attack_type()
	
	if attack_type == Globals.Attack.MELEE:
		# Set the correct attack type for the melee damage areas
		if Globals.Trait.SLASHING in weapon_traits:
			melee_damage_area.damage_type = Globals.Trait.SLASHING
		elif Globals.Trait.EXPLOSIVE in weapon_traits:
			melee_damage_area.damage_type = Globals.Trait.EXPLOSIVE
		elif Globals.Trait.SMASH in weapon_traits:
			melee_damage_area.damage_type = Globals.Trait.SMASH
		elif Globals.Trait.FIRE in weapon_traits:
			melee_damage_area.damage_type = Globals.Trait.FIRE
		else:
			# All other traits will not have a special interaction, so set the type to -1
			melee_damage_area.damage_type = -1
		attack_animation_player.play("slash")
	elif attack_type == Globals.Attack.RANGED:
		attack_animation_player.play("slash") # TODO: ranged attack

func can_attack() -> bool:
	return attack_cooldown_timer.is_stopped() and in_control

func can_aim() -> bool:
	return attack_cooldown_timer.is_stopped() and in_control

# TODO: currently this returns the main weapon only
func get_equipped_weapon_data() -> Dictionary:
	var weapon = metaboy.metaboy_data.weapon
	if weapon.empty():
		push_warning("Warning: Could not get the weapon name of the player's MetaBoy.")
		weapon = "Admin-Tool" # Default to admin tool
	
	var weapon_data = Globals.weapon_data.get(weapon)
	return weapon_data

# Returns the list of traits belonging to this MetaBoy's main weapon.
func get_weapon_traits() -> Array:
	var weapon = metaboy.metaboy_data.weapon
	if weapon.empty():
		push_warning("Warning: Could not get the weapon name of the player's MetaBoy.")
		weapon = "Admin-Tool" # Default to admin tool
	
	var weapon_data = Globals.weapon_data.get(weapon)
	var weapon_traits = weapon_data.get("Traits", [])
	return weapon_traits

# Returns the attack type of this MetaBoy's main weapon.
func get_weapon_attack_type() -> int:
	var weapon = metaboy.metaboy_data.weapon
	if weapon.empty():
		push_warning("Warning: Could not get the weapon name of the player's MetaBoy.")
		weapon = "Admin-Tool" # Default to admin tool
	
	var weapon_data = Globals.weapon_data.get(weapon)
	var weapon_attack_type = weapon_data.get("Attack", -1)
	return weapon_attack_type
