extends Node2D

onready var metaboy_main = $"%MetaBoyCharacter"

func _ready():
	metaboy_main.set_attributes(MetaBoyGlobals.selected_metaboy.get_attributes_as_dictionary())
