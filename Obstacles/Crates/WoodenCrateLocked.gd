extends "res://Obstacles/Crates/WoodenCrate.gd"

func _ready():
	open_button.queue_free()

func get_object_name() -> String:
	return "Wooden Crate (Locked)"

# Locked wooden crates have picklock as an additional trait
func on_picklocked() -> void:
	print("Picklocked")
	queue_free()

# Overridden just in case this button shows up
func _on_open_button_pressed():
	pass
