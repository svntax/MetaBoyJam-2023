extends Node2D

onready var metaboy_main = $"%MetaBoyCharacter"

onready var items_root = $Items
onready var obstacles_root = $Obstacles
onready var enemies_root = $Enemies

onready var game_over_menu = $"%GameOverMenu"

onready var gems_destroyed = 0

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


func _on_PowerGem_power_gem_destroyed():
	gems_destroyed += 1
	check_win_condition()

func _on_PowerGem2_power_gem_destroyed():
	gems_destroyed += 1
	check_win_condition()

func _on_PowerGem3_power_gem_destroyed():
	gems_destroyed += 1
	check_win_condition()

func check_win_condition():
	if gems_destroyed >= 3:
		print("win")
