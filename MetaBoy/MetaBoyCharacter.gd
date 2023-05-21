extends KinematicBody2D

onready var speed = 160
onready var velocity = Vector2()

onready var metaboy = $MetaBoy
onready var attack_animation_player = $AttackAnimationPlayer
onready var attack_cooldown_timer = $AttackCooldownTimer
onready var melee_damage_area = $MeleeRoot/SlashDamageArea
onready var melee_root = $MeleeRoot
onready var ranged_root = $RangedRoot
onready var hp_bar = $HpBar
onready var damage_immunity_timer = $DamageImmunityTimer

# Projectiles
const WoodenStaffProjectile = preload("res://Weapons/Projectiles/WoodenStaffProjectile.tscn")
const STXBlasterProjectile = preload("res://Weapons/Projectiles/STXBlasterProjectile.tscn")
const BulletProjectile = preload("res://Weapons/Projectiles/BulletProjectile.tscn")

onready var bullet_speed = 880
onready var magic_bullet_speed = 360
onready var hp = 100

# If we want to be able to control different characters
onready var in_control = true

func _ready():
	metaboy.part_background.hide()
	melee_damage_area.source_shooter = self
	
	_connect_weapon_attack_signals()
	
	hp_bar.max_value = hp
	set_hp(hp)

func _connect_weapon_attack_signals():
	_connect_attack_signal("left_pistol_shoot", "_on_attack_animation_signal")
	_connect_attack_signal("right_pistol_shoot", "_on_attack_animation_signal")
	_connect_attack_signal("double_pistol_shoot", "_on_attack_animation_signal")

func _connect_attack_signal(signal_name: String, callback) -> void:
	if not metaboy.is_connected(signal_name, self, callback):
		metaboy.connect(signal_name, self, callback)

# Note: Assumes that any attack signal that emits comes from the metaboy's main weapon.
func _on_attack_animation_signal() -> void:
	shoot_projectile(metaboy.metaboy_data.weapon)

func is_being_controlled() -> bool:
	return in_control

func is_alive() -> bool:
	return hp > 0

func set_hp(value: int) -> void:
	hp = clamp(value, 0, hp_bar.max_value)
	hp_bar.value = hp

func damage(damage_data: Dictionary) -> void:
	if damage_immunity_timer.is_stopped():
		damage_immunity_timer.start()
		var damage_amount = damage_data.get("damage_amount", 1)
		set_hp(hp - damage_amount)
		if hp <= 0:
			hp = 0
			print("Player died")
			# TODO: player state machine
			pass#state_machine.set_state(state_machine.States.DEAD)
		else:
			print("Player hurt")
			pass#state_machine.set_state(state_machine.States.HURT)

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
		ranged_root.rotation = global_position.direction_to(get_global_mouse_position()).angle()
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
		melee_root.rotation = ranged_root.rotation
		
		# Set the correct attack type for the melee damage areas
		if Globals.Trait.SLASHING in weapon_traits:
			melee_damage_area.damage_type = "Slashing"
		elif Globals.Trait.EXPLOSIVE in weapon_traits:
			melee_damage_area.damage_type = "Explosive"
		elif Globals.Trait.SMASH in weapon_traits:
			melee_damage_area.damage_type = "Smash"
		elif Globals.Trait.FIRE in weapon_traits:
			melee_damage_area.damage_type = "Fire"
		else:
			# All other traits will not have a special interaction, so set the type to -1
			melee_damage_area.damage_type = -1
		attack_animation_player.play("slash")
	elif attack_type == Globals.Attack.RANGED:
		var will_play_animation = metaboy.play_attack_animation(metaboy.metaboy_data.weapon)
		if not will_play_animation:
			# No animation will play, so attack instantly
			shoot_projectile(metaboy.metaboy_data.weapon)

# TODO: implement all ranged weapons
func shoot_projectile(weapon: String) -> void:
	var projectile
	if weapon == "Wooden-Staff":
		projectile = WoodenStaffProjectile.instance()
		get_parent().add_child(projectile)
		projectile.source_shooter = self
		projectile.global_position = self.global_position
		var vel = Vector2(magic_bullet_speed, 0).rotated(ranged_root.rotation)
		projectile.set_velocity(vel)
	elif weapon == "STX-Blaster":
		projectile = STXBlasterProjectile.instance()
		get_parent().add_child(projectile)
		projectile.source_shooter = self
		projectile.global_position = metaboy.stx_blaster_spawn_pos.global_position
		var vel = Vector2(magic_bullet_speed, 0).rotated(ranged_root.rotation)
		projectile.set_velocity(vel)
		projectile.set_direction(vel)
	elif weapon == "Cowboy-Left-Pistol":
		projectile = BulletProjectile.instance()
		get_parent().add_child(projectile)
		projectile.source_shooter = self
		projectile.global_position = metaboy.left_pistol_spawn.global_position
		var vel = Vector2(bullet_speed, 0).rotated(ranged_root.rotation)
		projectile.set_velocity(vel)
		projectile.set_direction(vel)
	elif weapon == "Cowboy-Right-Pistol":
		projectile = BulletProjectile.instance()
		get_parent().add_child(projectile)
		projectile.source_shooter = self
		projectile.global_position = metaboy.right_pistol_spawn.global_position
		var vel = Vector2(bullet_speed, 0).rotated(ranged_root.rotation)
		projectile.set_velocity(vel)
		projectile.set_direction(vel)
	elif weapon == "Cowboy-Both-Pistols" or weapon == "Cowboy-Two-Pistols":
		projectile = BulletProjectile.instance()
		get_parent().add_child(projectile)
		projectile.source_shooter = self
		projectile.global_position = metaboy.right_pistol_spawn.global_position
		var vel = Vector2(bullet_speed, 0).rotated(ranged_root.rotation)
		projectile.set_velocity(vel)
		projectile.set_direction(vel)
	
	if projectile != null:
		projectile.z_index = z_index + 1

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

func get_item_traits_in_inventory() -> Array:
	var combined_traits = []
	var inventory_menus = get_tree().get_nodes_in_group("InventoryMenu")
	if inventory_menus.empty():
		push_warning("WARNING: Inventory menu was null in get_item_traits_in_inventory().")
	var inventory_menu = inventory_menus[0]
	if inventory_menu == null:
		push_warning("WARNING: Inventory menu was null in get_item_traits_in_inventory().")
	else:
		for slot in inventory_menu.inventory_slots:
			var item_data = slot.get_item_data()
			var item_traits = item_data.get("Traits", [])
			if not item_traits.empty():
				combined_traits.append_array(item_traits)
	
	return combined_traits

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
