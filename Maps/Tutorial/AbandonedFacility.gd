extends Node2D

onready var metaboy_main = $"%MetaBoyCharacter"

onready var items_root = $Items
onready var obstacles_root = $Obstacles
onready var enemies_root = $Enemies

func _ready():
	metaboy_main.set_attributes(MetaBoyGlobals.selected_metaboy.get_attributes_as_dictionary())

func get_player() -> Node2D:
	return metaboy_main
