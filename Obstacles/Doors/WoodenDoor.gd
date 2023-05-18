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
	return "Wooden Door"
