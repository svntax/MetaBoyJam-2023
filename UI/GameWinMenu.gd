extends Control

onready var display_delay_timer = $DisplayDelayTimer

func _ready():
	hide()

func display() -> void:
	get_tree().paused = true
	display_delay_timer.start()

func _on_ExitButton_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://UI/LoginScreen.tscn")

func _on_DisplayDelayTimer_timeout():
	show()
