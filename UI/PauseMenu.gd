extends PanelContainer

func _ready():
	hide()

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		if get_tree().paused:
			get_tree().paused = false
			hide()
		else:
			get_tree().paused = true
			show()

func _on_ResumeButton_pressed():
	get_tree().paused = false
	hide()

func _on_QuitButton_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://UI/LoginScreen.tscn")
