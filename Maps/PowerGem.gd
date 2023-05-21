extends StaticBody2D

signal power_gem_destroyed()

onready var ui_root = $UI
onready var hp_bar = $"%HpBar"

onready var hit_sound = $HitSound

onready var navigation_agent = $NavigationAgent2D

onready var hp = 120

export (bool) var use_pathfinding = true

func _ready():
	hp_bar.max_value = hp
	set_hp(hp)

func damage(damage_data: Dictionary) -> void:
	var damage_amount = damage_data.get("damage_amount", 1)
	set_hp(hp - damage_amount)
	hit_sound.play()
	if hp <= 0:
		hp = 0
		emit_signal("power_gem_destroyed")
		queue_free()

func set_hp(value: int) -> void:
	hp = clamp(value, 0, hp_bar.max_value)
	hp_bar.value = hp
