extends ShotProjectile

# Overridden for custom effect
func damage(_damage_data: Dictionary) -> void:
	if alive:
		alive = false
		body.hide()
		# TODO: burn effect instead of immediate removal
		destroy()

func should_remove_on_collision(other) -> bool:
	return .should_remove_on_collision(other)

func _on_VisibilityNotifier2D_screen_exited():
	destroy()
