extends Node2D

onready var tutorial_map_panel = $UI/MapInfoTutorial
onready var city_map_panel = $UI/MapInfoCity
onready var play_button = $UI/PlayButton

# 1 = tutorial, 2 = city
onready var selection = 1

func _ready():
	tutorial_map_panel.hide()
	city_map_panel.hide()
	play_button.hide()

func _on_TutorialMapButton_pressed():
	selection = 1
	tutorial_map_panel.visible = !tutorial_map_panel.visible
	play_button.visible = tutorial_map_panel.visible
	city_map_panel.hide()

func _on_CityMapButton_pressed():
	selection = 2
	tutorial_map_panel.hide()
	city_map_panel.visible = !city_map_panel.visible
	play_button.visible = city_map_panel.visible

func _on_PlayButton_pressed():
	if selection == 1:
		get_tree().change_scene("res://Maps/Tutorial/AbandonedFacility.tscn")
	elif selection == 2:
		# TODO
		print("City map")

func _on_BackButton_pressed():
	get_tree().change_scene("res://UI/CharacterDisplayScreen.tscn")
