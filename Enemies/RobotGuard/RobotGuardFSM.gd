extends "res://StateMachine.gd"

# States: IDLE, WALK, PUSHED
enum States {ALERT, IDLE, MOVE, DEAD}

func _ready():
	call_deferred("set_state", States.IDLE)

func _state_logic(_delta):
	if state == States.MOVE:
		actor.move_towards_target()

func _state_transition(_delta):
	if state == States.IDLE:
		if actor.check_player_in_range():
			set_state(States.ALERT)
		else:
			set_state(States.IDLE)
	elif state == States.MOVE:
		if not actor.player.is_alive():
			set_state(States.IDLE)

func _enter_state(new_state, old_state):
	match new_state:
		States.ALERT:
			actor.alert_duration_timer.start()
			actor.animation_player.play("alert")
			actor.target = actor.player
		States.IDLE:
			actor.target = null
			pass#actor.animation_player.play("idle")
		States.MOVE:
			actor.update_path_to_target()
			actor.find_target_timer.start()
		States.DEAD:
			actor.die()

func _exit_state(old_state, new_state):
	match old_state:
		States.MOVE:
			actor.find_target_timer.stop()
