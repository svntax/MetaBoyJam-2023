extends KinematicBody2D
class_name RobotGuard

signal path_changed(path)

onready var body_root = $Body
onready var state_machine = $StateMachine
onready var animation_player = $AnimationPlayer
onready var effect_player = $EffectAnimationPlayer
onready var detect_area = $"%DetectArea"
onready var damage_immunity_timer = $DamageImmunityTimer
onready var hp_bar = $"%HpBar"
onready var alert_duration_timer = $AlertDurationTimer
onready var find_target_timer = $FindTargetTimer
onready var melee_root = $MeleeRoot
onready var melee_damage_area = $MeleeRoot/SlashDamageArea
onready var attack_timer = $AttackTimer
onready var attack_animation_player = $AttackAnimationPlayer

onready var navigation_agent = $NavigationAgent2D

onready var player = null
onready var target = player
onready var target_pos = Vector2()
onready var speed = 96
onready var hp = 20
onready var melee_damage = 5
onready var velocity = Vector2()
onready var chase_radius = 360

export (bool) var use_pathfinding = true

func _ready():
	player = get_tree().get_nodes_in_group("Players")[0]
	if randf() < 0.5:
		body_root.scale.x = -1
	hp_bar.max_value = hp
	set_hp(hp)
	detect_area.add_to_group("DetectAreas")
	
	melee_damage_area.source_shooter = self
	melee_damage_area.set_damage_amount(melee_damage)

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
	
	var target_pos
	if use_pathfinding:
		target_pos = navigation_agent.get_next_location()
	else:
		target_pos = target.global_position
	
	var dir = global_position.direction_to(target_pos)
	velocity = dir * speed
	if velocity.x >= 1:
		body_root.scale.x = 1
	elif velocity.x <= -1:
		body_root.scale.x = -1
	navigation_agent.set_velocity(velocity)
	
	if not _arrived_at_location():
		move_and_slide(velocity)
	else:
		pass
	# TODO: attack if walking towards the player

func _arrived_at_location() -> bool:
	return navigation_agent.is_navigation_finished()

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

func _on_FindTargetTimer_timeout():
	if state_machine.state == state_machine.States.MOVE:
		if use_pathfinding:
			update_path_to_target()
		find_target_timer.start()
		if target != null:
			# Target got away
			if target.global_position.distance_squared_to(self.global_position) >= chase_radius * chase_radius:
				state_machine.set_state(state_machine.States.IDLE)

func update_path_to_target():
	if target != null:
		navigation_agent.set_target_location(target.global_position)

func _on_NavigationAgent2D_path_changed():
	emit_signal("path_changed", navigation_agent.get_nav_path())

func _on_AttackTimer_timeout():
	attack_timer.start()
	if player != null:
		melee_root.rotation = global_position.direction_to(player.global_position).angle()
		var dist_sq = global_position.distance_squared_to(player.global_position)
		if dist_sq <= 80 * 80:
			attack_animation_player.play("slash")
