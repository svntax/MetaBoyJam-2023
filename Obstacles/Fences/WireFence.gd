extends StaticBody2D

onready var sprite = $Sprite

func get_object_name() -> String:
	return "Wire Fence"

# Interaction callbacks
func on_exploded() -> void:
	print("Exploded")
	queue_free()

func on_slashed() -> void:
	print("Slashed")
	queue_free()
