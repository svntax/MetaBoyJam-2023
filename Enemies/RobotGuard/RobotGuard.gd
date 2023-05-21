extends KinematicBody2D
class_name RobotGuard

onready var body_root = $Body
onready var state_machine = $StateMachine
onready var animation_player = $AnimationPlayer
onready var effect_player = $EffectAnimationPlayer
onready var detect_area = $"%DetectArea"
onready var damage_immunity_timer = $DamageImmunityTimer
onready var hp_bar = $"%HpBar"
onready var alert_duration_timer = $AlertDurationTimer

onready var player = null
onready var target = player
onready var speed = 96
onready var hp = 20
onready var velocity = Vector2()

func _ready():
	player = get_tree().get_nodes_in_group("Players")[0]
	if randf() < 0.5:
		body_root.scale.x = -1
	hp_bar.max_value = hp
	set_hp(hp)
	detect_area.add_to_group("DetectAreas")

func _on_PlayerDetectArea_body_entered(body):
	if body == player:
		if state_machine.state == state_machine.States.SLEEP:
			state_machine.set_state(state_machine.States.IDLE)

func _on_PlayerDetectArea_body_exited(body):
	if body == player:
		if state_machine.state == state_machine.States.MOVE:
			state_machine.set_state(state_machine.States.IDLE)

func damage(damage_data: Dictionary) -> void:
	if damage_immunity_timer.is_stopped():
		damage_immunity_timer.start()
		var damage_amount = damage_data.get("damage_amount", 1)
		set_hp(hp - damage_amount)
		if hp <= 0:
			hp = 0
			state_machine.set_state(state_machine.States.DEAD)
		else:
			effect_player.play("damage")

func set_hp(value: int) -> void:
	hp = clamp(value, 0, hp_bar.max_value)
	hp_bar.value = hp

func die() -> void:
	hide()
	set_deferred("collision_layer", 0)
	set_deferred("collision_mask", 0)
	queue_free()

func check_player_in_range() -> bool:
	return player in detect_area.get_overlapping_bodies()

func move_towards_target() -> void:
	if target == null:
		return
	
	var dir = global_position.direction_to(target.global_position)
	velocity = dir * speed
	if velocity.x >= 1:
		body_root.scale.x = 1
	elif velocity.x <= -1:
		body_root.scale.x = -1
	move_and_slide(velocity)
	# TODO: attack if walking towards the player

func _on_ImmunityTimer_timeout():
	if state_machine.state == state_machine.States.HURT:
		state_machine.set_state(state_machine.States.IDLE)

func _on_DetectArea_body_entered(body):
	handle_object_entered(body)

func _on_DetectArea_area_entered(area):
	handle_object_entered(area)

func handle_object_entered(other):
	if other == player:
		pass

func _on_AlertDurationTimer_timeout():
	if state_machine.state == state_machine.States.ALERT:
		state_machine.set_state(state_machine.States.MOVE)
