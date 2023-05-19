extends StaticBody2D

enum Direction {DOWN, LEFT, RIGHT}
export (Direction) var direction = Direction.DOWN

onready var sprite = $Sprite

func _ready():
	if direction == Direction.LEFT:
		# Assume it's the sideways door
		sprite.flip_h = true
	else:
		sprite.flip_h = false

func get_object_name() -> String:
	return "Iron Door"

# Interaction callbacks
func on_hacked() -> void:
	print("Hacked")
	queue_free()

func on_burned() -> void:
	print("Burned")
	queue_free()
