extends StaticBody2D

signal activated()
signal deactivated()

export (Array, NodePath) var object_receivers = []

onready var animation_player = $AnimationPlayer

func _ready():
	for object in object_receivers:
		add_object_connection(object)

func add_object_connection(object: Node2D) -> void:
	if object.has_method("on_activated"):
		self.connect("activated", object, "on_activated")
	if object.has_method("on_deactivated"):
		self.connect("deactivated", object, "on_deactivated")

func activate() -> void:
	emit_signal("activated")
	animation_player.play("activate")

func deactivate() -> void:
	emit_signal("deactivated")
	animation_player.play("deactivate")
