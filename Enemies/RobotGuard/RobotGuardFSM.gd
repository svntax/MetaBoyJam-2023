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
			actor.target = actor.player
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
		States.IDLE:
			actor.target = null
			pass#actor.animation_player.play("idle")
		States.MOVE:
			pass
		States.DEAD:
			actor.die()
