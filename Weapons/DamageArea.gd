extends Area2D

export (String) var damage_type = "" setget set_damage_type, get_damage_type

var source_shooter = null

onready var damage_data = {
	"source_object": self,
	"damage_amount": 1
}

# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("body_entered", self, "_on_body_entered")

func set_damage_data(data: Dictionary) -> void:
	damage_data = {
		"source_object": data.get("source_object", self),
		"damage_amount": data.get("damage_amount", 1)
	}

func set_damage_type(type: String) -> void:
	damage_type = type
#	if type == Globals.Trait.SLASHING:
#		damage_type = "Slashing"
#	elif type == Globals.Trait.EXPLOSIVE:
#		damage_type = "Explosive"
#	elif type == Globals.Trait.SMASH:
#		damage_type = "Smash"
#	elif type == Globals.Trait.FIRE:
#		damage_type = "Fire"
#	else:
#		damage_type = "Slashing"

func get_damage_type() -> String:
	return damage_type
#	if damage_type == "Slashing":
#		return Globals.Trait.SLASHING
#	elif damage_type == "Explosive":
#		return Globals.Trait.EXPLOSIVE
#	elif damage_type == "Smash":
#		return Globals.Trait.SMASH
#	elif damage_type == "Fire":
#		return Globals.Trait.FIRE
#
#	return Globals.Trait.SLASHING

func _on_body_entered(other):
	if source_shooter != null and other == source_shooter:
		return
	
	# Normal trigger/activation
	if other.has_method("damage"):
		other.call_deferred("damage", damage_data)
	
	# Trait-specific trigger/activation
	if other.has_method("on_slashed") and damage_type == "Slashing":
		other.call_deferred("on_slashed")
	if other.has_method("on_exploded") and damage_type == "Explosive":
		other.call_deferred("on_exploded")
	if other.has_method("on_smashed") and damage_type == "Smash":
		other.call_deferred("on_smashed")
	if other.has_method("on_burned") and damage_type == "Fire":
		other.call_deferred("on_burned")
