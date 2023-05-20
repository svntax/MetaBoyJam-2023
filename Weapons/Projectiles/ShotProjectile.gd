extends Node2D
class_name ShotProjectile

var source_shooter = null setget set_source_shooter

onready var speed = 128
onready var velocity = Vector2()
onready var alive = true

export (int) var damage = 1

onready var body = $Sprite
onready var damage_area = $DamageArea

func _ready():
	damage_area.connect("body_entered", self, "_on_body_entered")
	damage_area.connect("area_entered", self, "_on_area_entered")
	damage_area.set_damage_data({
		"source_object": self,
		"damage_amount": damage
	})

func set_source_shooter(source) -> void:
	source_shooter = source
	damage_area.source_shooter = source

func set_velocity(vel: Vector2) -> void:
	velocity = vel

func set_direction(_dir: Vector2) -> void:
	pass # If we need to rotate the projectile sprite

func _physics_process(delta):
	if alive:
		global_position += velocity * delta

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
	
	# Damage method is not called here because DamageArea handles it
	
	if should_remove_on_collision(other):
		alive = false
		body.hide()
		damage_area.collision_layer = 0
		damage_area.collision_mask = 0
		destroy()

func destroy() -> void:
	queue_free()

func should_remove_on_collision(_other) -> bool:
	return true
