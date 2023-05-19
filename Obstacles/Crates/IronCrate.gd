extends StaticBody2D

onready var sprite = $Sprite

func get_object_name() -> String:
	return "Iron Crate"

# Interaction callbacks
func on_hacked() -> void:
	print("Hacked")
	queue_free()

func on_burned() -> void:
	print("Burned")
	queue_free()
