extends Area2D

export (Globals.Trait) var damage_type = Globals.Trait.SLASHING

# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("body_entered", self, "_on_body_entered")

func set_damage_type(type: int) -> void:
	damage_type = type

func _on_body_entered(other):
	# Normal trigger/activation
	if other.has_method("damage"):
		other.damage()
	
	# Trait-specific trigger/activation
	if other.has_method("on_slashed") and damage_type == Globals.Trait.SLASHING:
		other.on_slashed()
	if other.has_method("on_exploded") and damage_type == Globals.Trait.EXPLOSIVE:
		other.on_exploded()
	if other.has_method("on_smashed") and damage_type == Globals.Trait.SMASH:
		other.on_smashed()
	if other.has_method("on_burned") and damage_type == Globals.Trait.FIRE:
		other.on_burned()
