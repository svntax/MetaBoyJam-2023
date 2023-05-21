extends ShotProjectile

onready var animation_player = $AnimationPlayer
onready var explode_sound = $ExplodeSound
onready var explosion_particles = $ExplosionParticles

func _ready():
	animation_player.play("shot", -1, 2)

# Overridden, this projectile simply rotates towards the given vector
func set_direction(dir: Vector2) -> void:
	self.rotation = dir.angle()

# Overridden for custom effect
func damage(_damage_data: Dictionary) -> void:
	if alive:
		alive = false
		body.hide()
		# TODO: explosion effect instead of immediate removal
		destroy()

func should_remove_on_collision(other) -> bool:
	return .should_remove_on_collision(other)

func _on_VisibilityNotifier2D_screen_exited():
	destroy()

func destroy() -> void:
	explode_sound.play()
	explosion_particles.emitting = true
	rotation = 0

func _on_ExplodeSound_finished():
	queue_free()
