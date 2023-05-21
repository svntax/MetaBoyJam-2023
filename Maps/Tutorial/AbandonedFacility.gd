extends Node2D

onready var metaboy_main = $"%MetaBoyCharacter"

onready var items_root = $Items
onready var obstacles_root = $Obstacles
onready var enemies_root = $Enemies

onready var game_over_menu = $"%GameOverMenu"

func _ready():
	metaboy_main.set_attributes(MetaBoyGlobals.selected_metaboy.get_attributes_as_dictionary())
	metaboy_main.connect("died", self, "_on_player_died")
	# TEST
#	metaboy_main.set_attributes({
#		"Weapon": "STX-Blaster"
#	})

func get_player() -> Node2D:
	return metaboy_main

func _on_player_died() -> void:
	game_over_menu.display()
