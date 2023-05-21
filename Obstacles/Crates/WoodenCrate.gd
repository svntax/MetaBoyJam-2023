extends StaticBody2D

export (NodePath) var loot_table_path = NodePath()
var loot_table

onready var sprite = $Sprite
onready var open_button = $"%OpenButton"

func _ready():
	open_button.connect("pressed", self, "_on_open_button_pressed")
	loot_table = get_node_or_null(loot_table_path)

func _on_open_button_pressed():
	print("Opened wooden crate")
	drop_loot()
	queue_free()

func get_object_name() -> String:
	return "Wooden Crate"

func drop_loot() -> void:
	if loot_table == null:
		return
	
	var item = loot_table.drop_item()
	if item == null:
		push_error("Error: Attempted to drop a null item in " + self.name)
		return
	item.global_position = self.global_position

# Interaction callbacks
func on_exploded() -> void:
	print("Exploded")
	drop_loot()
	queue_free()

func on_smashed() -> void:
	print("Smashed")
	drop_loot()
	queue_free()

func on_burned() -> void:
	print("Burned")
	drop_loot()
	queue_free()
