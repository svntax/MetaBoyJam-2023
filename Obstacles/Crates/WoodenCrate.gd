extends StaticBody2D

onready var sprite = $Sprite
onready var open_button = $"%OpenButton"

func _ready():
	open_button.connect("pressed", self, "_on_open_button_pressed")

func _on_open_button_pressed():
	print("Opened wooden crate")
	queue_free()

func get_object_name() -> String:
	return "Wooden Crate"

# Interaction callbacks
func on_exploded() -> void:
	print("Exploded")
	queue_free()

func on_smashed() -> void:
	print("Smashed")
	queue_free()

func on_burned() -> void:
	print("Burned")
	queue_free()
