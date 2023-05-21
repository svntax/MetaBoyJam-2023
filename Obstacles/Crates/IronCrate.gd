extends StaticBody2D

export (NodePath) var loot_table_path = NodePath()
var loot_table

onready var sprite = $Sprite

func _ready():
	loot_table = get_node_or_null(loot_table_path)

func get_object_name() -> String:
	return "Iron Crate"

func drop_loot() -> void:
	var loot_table = get_node_or_null(loot_table_path)
	if loot_table == null:
		return
	
	var item = loot_table.drop_item()
	item.global_position = self.global_position

# Interaction callbacks
func on_hacked() -> void:
	print("Hacked")
	drop_loot()
	queue_free()

func on_burned() -> void:
	print("Burned")
	drop_loot()
	queue_free()
