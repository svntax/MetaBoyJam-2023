extends KinematicBody2D

onready var explosion_particles = $ExplosionParticles

# Hacky, copied from ShotProjectile, should be a more generic physics-based
# projectile class.

var source_shooter = null setget set_source_shooter

onready var speed = 128
onready var velocity = Vector2()
onready var alive = true

export (int) var damage_amount = 1

onready var body = $Sprite
onready var damage_area = $DamageArea
onready var explosion_area = $ExplosionArea
onready var explode_timer = $ExplodeTimer
onready var explode_sound = $ExplodeSound

func _ready():
	damage_area.connect("body_entered", self, "_on_body_entered")
	damage_area.connect("area_entered", self, "_on_area_entered")
	damage_area.set_damage_data({
		"source_object": self,
		"damage_amount": damage_amount
	})
	
	explosion_area.add_to_group("DetectAreas")
	
	explode_timer.start()

func set_source_shooter(source) -> void:
	source_shooter = source
	damage_area.source_shooter = source

func set_velocity(vel: Vector2) -> void:
	velocity = vel
	speed = velocity.length()

func set_direction(_dir: Vector2) -> void:
	pass # If we need to rotate the projectile sprite

func _physics_process(delta):
	if alive:
		if speed > 0:
			speed -= 32
		elif speed < 0:
			speed += 32
		if abs(speed) <= 32:
			if speed < 32:
				speed -= 8
			elif speed > -32:
				speed += 8
		if abs(speed) <= 8:
			speed = 0
		var new_vel = move_and_slide(velocity)
		# Friction
		velocity = velocity.normalized() * speed
		#global_position += velocity * delta

func damage(_damage_data: Dictionary) -> void:
	if alive:
		alive = false
		body.hide()
		destroy()

func _on_body_entered(other_body):
	_handle_object_entered(other_body)

func _on_area_entered(other_area):
	_handle_object_entered(other_area)

func _handle_object_entered(other) -> void:
	if source_shooter != null and other == source_shooter:
		return
	
	if not alive:
		return
	
	if other.is_in_group("PickupItems"):
		return
	if other.is_in_group("DetectAreas"):
		return
	
	# Damage method is not called here because DamageArea handles it
	
	if should_remove_on_collision(other):
		alive = false
		body.hide()
		damage_area.collision_layer = 0
		damage_area.collision_mask = 0
		destroy()

func destroy() -> void:
	explode()

func should_remove_on_collision(other) -> bool:
	return false

func _on_VisibilityNotifier2D_screen_exited():
	pass

func _on_ExplodeTimer_timeout():
	explode()

func explode() -> void:
	var damage_data = {
		"source_object": self,
		"damage_amount": damage_amount
	}

	if alive:
		alive = false
		collision_layer = 0
		collision_mask = 0
		body.hide()
		explode_sound.play()
		explosion_particles.emitting = true
		for other_body in explosion_area.get_overlapping_bodies():
			if other_body == self:
				continue
	
			deal_damage_to(other_body, damage_data)
		for other_area in explosion_area.get_overlapping_areas():
			deal_damage_to(other_area, damage_data)
		
		explosion_area.collision_layer = 0
		explosion_area.collision_mask = 0

func deal_damage_to(other, damage_data) -> void:
	if other.has_method("damage"):
		other.damage(damage_data)
	
	if other.has_method("on_exploded"):
		print(damage_area.get_damage_type())
		print("DO EXPLOSION")
	# Trait-specific trigger/activation
	if other.has_method("on_slashed") and damage_area.get_damage_type() == "Slashing":
		other.call_deferred("on_slashed")
	if other.has_method("on_exploded") and damage_area.get_damage_type() == "Explosive":
		other.call_deferred("on_exploded")
	if other.has_method("on_smashed") and damage_area.get_damage_type() == "Smash":
		other.call_deferred("on_smashed")
	if other.has_method("on_burned") and damage_area.get_damage_type() == "Fire":
		other.call_deferred("on_burned")
